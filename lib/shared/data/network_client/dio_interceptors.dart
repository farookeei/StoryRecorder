// import 'dart:developer';

// import 'package:dio/dio.dart';

// class Logging extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     log('REQUEST[${options.method}] => PATH: ${options.path}');
//     if (options.data != null) log('REQUEST DATA => ${options.data}');
//     log('REQUEST HEADERS => ${options.headers}');
//     print('REQUEST[${options.method}] => PATH: ${options.path}');
//     if (options.data != null) log('REQUEST DATA => ${options.data}');
//     print('REQUEST HEADERS => [${options.headers}]');
//     return super.onRequest(options, handler);
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     log(
//       'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
//     );
//     log('RESPONSE DATA => ${response.data}');
//     print(
//       'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
//     );
//     print('RESPONSE DATA => ${response.data}');
//     return super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler) {
//     log(
//       'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
//     );
//     log("Error: ${err.response?.data}");
//     print(
//       'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
//     );
//     print("Error: ${err.response?.data}");
//     return super.onError(err, handler);
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:colorize/colorize.dart';
import 'package:dio/dio.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A simple dio log interceptor (mainly inspired by the built-in dio
/// `LogInterceptor`), which has coloring features and json formatting
/// so you can have a better readable output.
class AwesomeDioInterceptor extends QueuedInterceptor {
  /// Creates a colorful dio logging interceptor, which has the following:
  /// `requestStyle`: The request color style, defaults to `YELLOW`
  ///
  /// `responseStyle`: The response color style, defaults to `GREEN`
  ///
  /// `errorStyle`: The error response color style, defaults to `RED`
  ///
  /// `logRequestHeaders`: Whether to log the request headers or not,
  /// it should minimize the logging output.
  ///
  /// `logResponseHeaders`: Whether to log the response headrers or not,
  /// it should minimize the logging output.
  ///
  /// `logRequestTimeout`: Whether to log the request timeout info or not,
  /// it should minimize the logging output.
  ///
  /// `logger`: if you want to override the default logger which is `log`,
  /// you can set any printer or logger you prefer.. just pass a refrence
  /// of your function to this function parameter and you're good to go.
  ///
  /// **Example**
  ///
  /// ```dart
  /// dio.interceptors.add(
  ///   AwesomeDioInterceptor(
  ///     logRequestTimeout: false,
  ///
  ///     // Optional, defaults to the 'log' function in the 'dart:developer'
  ///     // package
  ///     logger: debugPrint,
  ///   ),
  /// );
  /// ```
  AwesomeDioInterceptor({
    Styles? requestStyle,
    Styles? responseStyle,
    Styles? errorStyle,
    String? baseUrl,
    bool logRequestHeaders = true,
    bool logResponseHeaders = true,
    bool logRequestTimeout = true,
    void Function(String log)? logger,
  })  : _jsonEncoder = const JsonEncoder.withIndent('  '),
        _baseUrl = baseUrl ?? '',
        _requestStyle = requestStyle ?? _defaultRequestStyle,
        _responseStyle = responseStyle ?? _defaultResponseStyle,
        _errorStyle = errorStyle ?? _defaultErrorStyle,
        _logRequestHeaders = logRequestHeaders,
        _logResponseHeaders = logResponseHeaders,
        _logRequestTimeout = logRequestTimeout,
        _logger = logger ?? log;

  static const Styles _defaultRequestStyle = Styles.YELLOW;
  static const Styles _defaultResponseStyle = Styles.GREEN;
  static const Styles _defaultErrorStyle = Styles.RED;

  static String? _token;
  static String? _refreshToken;

  final String _baseUrl;
  late final JsonEncoder _jsonEncoder;
  late final bool _logRequestHeaders;
  late final bool _logResponseHeaders;
  late final bool _logRequestTimeout;
  late final void Function(String log) _logger;

  late final Styles _requestStyle;
  late final Styles _responseStyle;
  late final Styles _errorStyle;

  void _log({required String key, required String value, Styles? style}) {
    final coloredMessage = Colorize('$key$value').apply(
      style ?? Styles.LIGHT_GRAY,
    );
    //? for getting in terminal
    print(coloredMessage);
    _logger('$coloredMessage');
  }

  void _logJson({
    required String key,
    dynamic value,
    Styles? style,
    bool isResponse = false,
  }) {
    final isFormData = value.runtimeType == FormData;
    final isValueNull = value == null;

    final encodedJson = _jsonEncoder.convert(
      isFormData ? Map.fromEntries((value as FormData).fields) : value,
    );
    _log(
      key: isResponse
          ? key
          : '${isFormData ? '[formData.fields]' : !isValueNull ? '[Json]' : ''} $key',
      value: encodedJson,
      style: style,
    );

    if (isFormData && !isResponse) {
      final files = (value as FormData)
          .files
          .map((e) => e.value.filename ?? 'Null or Empty filename')
          .toList();
      if (files.isNotEmpty) {
        final encodedJson = _jsonEncoder.convert(files);
        _log(
          key: '[formData.files] Request Body:\n',
          value: encodedJson,
          style: style,
        );
      }
    }
  }

  void _logHeaders({required Map headers, Styles? style}) {
    _log(key: 'Headers:', value: '', style: style);
    headers.forEach((key, value) {
      _log(
        key: '\t$key: ',
        value: (value is List && value.length == 1)
            ? value.first
            : value.toString(),
        style: style,
      );
    });
  }

  void _logNewLine() => _log(key: '', value: '');

  void _logRequest(RequestOptions options, {Styles? style}) {
    _log(key: '[Request] ->', value: '', style: _requestStyle);
    _log(key: 'Uri: ', value: options.uri.toString(), style: _requestStyle);
    // _log(key: 'Method: ', value: options.method, style: _requestStyle);
    // _log(
    //   key: 'Response Type: ',
    //   value: options.responseType.toString(),
    //   style: style,
    // );
    // _log(
    //   key: 'Follow Redirects: ',
    //   value: options.followRedirects.toString(),
    //   style: style,
    // );
    // if (_logRequestTimeout) {
    //   _log(
    //     key: 'Connection Timeout: ',
    //     value: options.connectTimeout.toString(),
    //     style: style,
    //   );
    //   _log(
    //     key: 'Send Timeout: ',
    //     value: options.sendTimeout.toString(),
    //     style: style,
    //   );
    //   _log(
    //     key: 'Receive Timeout: ',
    //     value: options.receiveTimeout.toString(),
    //     style: style,
    //   );
    // }
    // _log(
    //   key: 'Receive Data When Status Error: ',
    //   value: options.receiveDataWhenStatusError.toString(),
    //   style: style,
    // );
    //   _log(key: 'Extra: ', value: options.extra.toString(), style: style);
    if (_logRequestHeaders) {
      _logHeaders(headers: options.headers, style: style);
    }
    _logJson(key: 'Request Body:\n', value: options.data, style: style);
  }

  void _logResponse(Response response, {Styles? style, bool error = false}) {
    if (!error) {
      _log(key: '[Response] ->', value: '', style: style);
    }
    _log(key: 'Uri: ', value: response.realUri.toString(), style: style);
    // _log(
    //   key: 'Request Method: ',
    //   value: response.requestOptions.method,
    //   style: style,
    // );
    // _log(key: 'Status Code: ', value: '${response.statusCode}', style: style);
    // if (_logResponseHeaders) {
    //   _logHeaders(headers: response.headers.map, style: style);
    // }
    _logJson(
      key: 'Response Body:\n',
      value: response.data,
      style: style,
      isResponse: true,
    );
  }

  void _logError(DioError err, {Styles? style}) {
    _log(key: '[Error] ->', value: '', style: style);
    _log(
      key: 'DioError: ',
      value: '[${err.type.toString()}]: ${err.message}',
      style: style,
    );
  }

  // void _delay() async => await Future.delayed(
  //       const Duration(milliseconds: 200),
  //     );

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    _logError(err, style: _errorStyle);

// Check if the error response is not null.
    if (err.response != null) {
      // Log the response with error status and defined style.
      _logResponse(err.response!, error: true, style: _errorStyle);
    }

    _logNewLine();

    // _delay();

    handler.next(err);
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //! options.headers["Authorization"] = getToken();

    //console log texts
    _logRequest(options, style: _requestStyle);
    _logNewLine();

    handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    _logResponse(response, style: _responseStyle);
    _logNewLine();
    handler.next(response);
  }

  // Future<void> updateTokens(Map<String, dynamic> responseData) async {
  //   resetToken();
  //   await Hive.box('appBox').putAll({
  //     "token": responseData['accessToken'] as String?,
  //     "refreshToken": responseData['refreshToken'] as String?
  //   });
  //   _token = responseData['accessToken'] as String?;
  //   _refreshToken = responseData['refreshToken'] as String?;
  //   final token = Hive.box('appBox').get("token");
  //   final refresh = Hive.box('appBox').get("refreshToken");
  //   print("$token, $refresh");
  // }

  // static String? getToken() {
  //   if (_token != null) return _token;
  //   _token = Hive.box('appBox').get("token");
  //   return _token;
  // }

  // static Future<String?> getRefreshToken() async {
  //   if (_refreshToken != null) return _refreshToken;
  //   _refreshToken = await Hive.box('appBox').get("refreshToken");
  //   return _refreshToken;
  // }

  // static Future<String?> getAccessToken() async {
  //   if (_token != null) return _token;
  //   _token = await Hive.box('appBox').get("token");
  //   return _token;
  // }

  // static resetToken() {
  //   _token = null;
  //   _refreshToken = null;
  // }
}
