import 'package:flutter/material.dart';
import 'package:test_sample/features/camera_page2.dart';

import '../../features/camera_page.dart';
import '../../themes/color_variables.dart';

class SplashScreen extends StatelessWidget {
  static const routName = "/splashscreen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraPage();

    // return CameraPage2();
  }
}
