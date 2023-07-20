import 'env_abstract.dart';

class TestConfig implements BaseConfig {
  @override
  // String get apiHost =>  "https://strapi-test.classaccess.io/";

  // String get apiHost => "http://192.168.0.222:5000";
  String get apiHost => "https://test.classaccess.io";
}

class DevConfig implements BaseConfig {
  @override
  // String get apiHost => "https://d2b7-117-232-142-13.in.ngrok.io";

  String get apiHost => "https://alpha.classaccess.io";
}

class ChallengeConfig implements BaseConfig {
  @override
  // String get apiHost => "http://192.168.0.191:5000";
  String get apiHost => "https://challenge.classaccess.io";
}

//?BETA
class StagingConfig implements BaseConfig {
  @override
  String get apiHost => "https://dev.classaccess.io";
}

class ProdConfig implements BaseConfig {
  @override
  String get apiHost => "https://classaccess.io";
}
