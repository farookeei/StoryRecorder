import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../themes/color_variables.dart';

class AppBarSettings {
  final bool showLogo;
  final bool showBack;
  final bool showCustomSupport;
  final bool showNotification;
  final bool showAccountDetails;
  final bool showChildSwitch;
  final String? pageTitle;
  final Color appBarColor;
  final Widget? customAction;
  AppBarSettings(
      {Key? key,
      this.showLogo = false,
      this.showBack = false,
      this.showCustomSupport = false,
      this.showNotification = false,
      this.showAccountDetails = false,
      this.showChildSwitch = false,
      this.pageTitle,
      this.appBarColor = ReplyColors.white,
      this.customAction});
}

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final AppBarSettings appBarSettings;
  final int? pagePostiion;
  final Function? refreshScaffold;
  MainAppBar(
      {Key? key,
      required this.appBarSettings,
      this.pagePostiion,
      this.refreshScaffold})
      : preferredSize = Size.fromHeight(kToolbarHeight.h),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  String? deviceId = "";
  String familyId = "";
  String guardianId = "";
  String servertoken = "";
  int touchcount = 0;
  String fcmToken = "";
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double actionGap = 14;
    return RepaintBoundary(
        child: ClipRRect(
      clipBehavior: Clip.hardEdge,
      // borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaY: 10, sigmaX: 30, tileMode: TileMode.mirror),
        child: AppBar(
          toolbarHeight: kToolbarHeight.h,
          // backgroundColor: widget.appBarSettings.appBarColor.withOpacity(0.9),
          backgroundColor: widget.appBarSettings.appBarColor.withOpacity(0.1),
          scrolledUnderElevation: 0,
          centerTitle: !widget.appBarSettings.showLogo,
          title: widget.appBarSettings.showLogo
              ? SvgPicture.asset(
                  "assets/icons/superr.svg",
                  height: 25.h,
                  // width: 40.w,
                )
              : Text(widget.appBarSettings.pageTitle ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: ReplyColors.blueBold, fontSize: 20.sp)),
          leadingWidth: _showLeading(
                  widget.appBarSettings.showCustomSupport,
                  widget.appBarSettings.showLogo,
                  widget.appBarSettings.showBack)
              ? 100.w
              : null,
          leading: _showLeading(
                  widget.appBarSettings.showCustomSupport,
                  widget.appBarSettings.showLogo,
                  widget.appBarSettings.showBack)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.appBarSettings.showBack
                        ? IconButton(
                            onPressed: () {
                              Navigator.canPop(context) == false
                                  ? SystemNavigator.pop()
                                  : Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: ReplyColors.blueExtraBold,
                              size: 22.h,
                            ),
                          )
                        : SizedBox(),
                    widget.appBarSettings.showCustomSupport &&
                            !widget.appBarSettings.showLogo
                        ? GestureDetector(
                            onTap: () async {},
                            child: _returnIconAppBar(
                                SvgPicture.asset(
                                  "assets/icons/customer_support.svg",
                                  height: 28.h,
                                ),
                                ReplyColors.blueLight),
                          )
                        : SizedBox(),
                  ],
                )
              : null,
          automaticallyImplyLeading: false,
          actions: [
            widget.appBarSettings.showCustomSupport &&
                    widget.appBarSettings.showLogo
                ? GestureDetector(
                    onTap: () async {},
                    child: _returnIconAppBar(
                        SvgPicture.asset(
                          "assets/icons/customer_support.svg",
                          height: 28.h,
                        ),
                        ReplyColors.blueLight),
                  )
                : SizedBox(),

            SizedBox(
              width: widget.appBarSettings.showAccountDetails ? actionGap : 0,
            ),

            SizedBox(
              width: widget.appBarSettings.showChildSwitch ? actionGap : 0,
            ),

            // ChildSwitch(pagePosition: 1)
          ],
        ),
      ),
    ));
  }
}

Widget _returnIconAppBar(Widget asset, Color color) {
  return CircleAvatar(
    backgroundColor: color,
    child: asset,
    radius: 20.r,
  );
}

bool _showLeading(showCustomSupport, showLogo, showBack) {
  bool customerSupport = showCustomSupport && !showLogo;
  return showBack || customerSupport;
}
