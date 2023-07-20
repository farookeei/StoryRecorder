import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/color_variables.dart';

enum ButtonState { enabled, loading, failure, success, disabled }

enum ButtonVariant { primary, secondary, tertiary, outlined }

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final ButtonState state;
  final Widget child;
  late Color? foregroundColor;
  late Color? backgroundColor;
  final double elevation;
  final String? disabledMsg;
  final ButtonVariant variant;
  final bool vibrate;
  final IconData? icon;

  final double? radius;
  final double? width;
  final double? height;
  final Alignment align;
  final double? tertiarySize;
  final ButtonStyle? style;
  final BorderSide isOutlineBorderRequire;
  final MaterialStateProperty<EdgeInsetsGeometry>? padding;

  CustomButton(
      {required this.onTap,
      this.state = ButtonState.enabled,
      required this.child,
      this.foregroundColor,
      this.backgroundColor,
      this.radius,
      this.elevation = 0,
      this.height,
      Key? key,
      this.disabledMsg,
      this.variant = ButtonVariant.primary,
      this.vibrate = false,
      this.icon,
      this.width,
      this.tertiarySize = 18,
      this.align = Alignment.bottomRight,
      this.isOutlineBorderRequire = BorderSide.none,
      this.style,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _onTap(context) {
      if (state == ButtonState.enabled && onTap != null) {
        return onTap!();
      } else if (state == ButtonState.disabled && disabledMsg != null) {
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(disabledMsg!),
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          // margin: EdgeInsets.only(bottom: 95),
          dismissDirection: DismissDirection.down,
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ));
      }
    }

    Color? _foregroundColor = foregroundColor != null
        ? foregroundColor
        : variant == ButtonVariant.primary
            ? ReplyColors.neutralLight
            : variant == ButtonVariant.secondary
                ? ReplyColors.blue75
                : ReplyColors.blue75;
    Color? _backgroundColor = backgroundColor != null
        ? backgroundColor
        : variant == ButtonVariant.primary
            ? ReplyColors.blue75
            : variant == ButtonVariant.secondary
                ? ReplyColors.blueLight
                : ReplyColors.neutralLight;

    return variant == ButtonVariant.tertiary
        ? TextButton(
            child: state == ButtonState.loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: _foregroundColor,
                    ),
                  )
                : child,
            onPressed: state == ButtonState.loading
                ? () {}
                : () {
                    _onTap(context);
                  },
            style: style ??
                ButtonStyle(
                  padding:
                      padding ?? MaterialStateProperty.all(EdgeInsets.zero),
                  textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: _foregroundColor, fontSize: tertiarySize),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius ?? 3.r),
                    ),
                  ),
                ),
          )
        : variant == ButtonVariant.outlined
            ? Align(
                alignment: align,
                child: ElevatedButton(
                    style: ButtonStyle(
                      padding: padding,
                      splashFactory: state == ButtonState.enabled
                          ? null
                          : NoSplash.splashFactory,
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius ?? 3.r),
                            side: BorderSide(
                              color: ReplyColors.blue75,
                            )),
                      ),
                      elevation: MaterialStateProperty.all(elevation),
                      overlayColor: MaterialStateProperty.all(
                          _foregroundColor!.withOpacity(0.2)),
                      backgroundColor: MaterialStateProperty.all(
                          state == ButtonState.disabled
                              ? ReplyColors.neutralLight
                              : Colors.transparent),
                    ),
                    onPressed: () {
                      _onTap(context);
                    },
                    child: child),
              )
            : Align(
                alignment: align,
                child: SizedBox(
                  width: width != null ? width : double.infinity,
                  height: height != null ? height : 56.h,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          padding: padding,
                          splashFactory: state == ButtonState.enabled
                              ? null
                              : NoSplash.splashFactory,
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(radius ?? 3.r),
                                side: isOutlineBorderRequire),
                          ),
                          elevation: MaterialStateProperty.all(elevation),
                          overlayColor: MaterialStateProperty.all(
                              _foregroundColor!.withOpacity(0.2)),
                          backgroundColor: MaterialStateProperty.all(
                              state == ButtonState.disabled
                                  ? ReplyColors.neutralLight
                                  : _backgroundColor),
                          foregroundColor: MaterialStateProperty.all(
                              state == ButtonState.disabled
                                  ? ReplyColors.neutral50
                                  : _foregroundColor),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.titleMedium)),
                      onPressed: () {
                        _onTap(context);
                      },
                      child: state == ButtonState.loading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                color: _foregroundColor,
                              ),
                            )
                          : state == ButtonState.failure
                              ? Icon(
                                  Icons.error_rounded,
                                  color: _foregroundColor,
                                )
                              : state == ButtonState.success
                                  ? Icon(
                                      Icons.check_circle,
                                      color: _foregroundColor,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Center(child: child)),
                                        icon != null
                                            ? SizedBox(width: 10)
                                            : SizedBox(),
                                        icon != null
                                            ? Icon(
                                                icon,
                                                color: _foregroundColor,
                                                size: 20,
                                              )
                                            : SizedBox()
                                      ],
                                    )),
                ),
              );
  }
}
