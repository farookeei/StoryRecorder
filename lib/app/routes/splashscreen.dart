import 'package:flutter/material.dart';

import '../../features/camera_page.dart';
import '../../themes/color_variables.dart';

class SplashScreen extends StatelessWidget {
  static const routName = "/splashscreen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CameraPage();
  }
}
