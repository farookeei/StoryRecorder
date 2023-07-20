import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_sample/themes/color_variables.dart';

import '../widgets/buttons/button.dart';
import 'camera_page.dart';

class NoPermissionScreen extends StatelessWidget {
  const NoPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ReplyColors.neutralBold,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "All Permissions were not granted\n",
          )),
          CustomButton(
            align: Alignment.center,
            onTap: () {
              openAppSettings();
            },
            width: 200.w,
            child: Text("Grant Permission"),
          ),
          SizedBox(
            height: 40.h,
          ),
          CustomButton(
            backgroundColor: ReplyColors.red100,
            align: Alignment.center,
            onTap: () {
              final route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => CameraPage(),
              );
              Navigator.pushReplacement(context, route);
            },
            width: 200.w,
            child: Text("Record"),
          )
        ],
      ),
    );
  }
}
