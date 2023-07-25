// import 'package:better_open_file/better_open_file.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_camera/flutter_camera.dart';

// class CameraPage2 extends StatefulWidget {
//   const CameraPage2({super.key});

//   @override
//   State<CameraPage2> createState() => _CameraPage2State();
// }

// class _CameraPage2State extends State<CameraPage2> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:

//             // Container(
//             //   color: Colors.white,
//             //   child: CameraAwesomeBuilder.awesome(
//             //     enableAudio: true,
//             //     mirrorFrontCamera: false,
//             //     saveConfig: SaveConfig.photoAndVideo(
//             //       // photoPathBuilder: () => path(CaptureMode.photo),
//             //       // videoPathBuilder: () => path(CaptureMode.video),
//             //       photoPathBuilder: () {
//             //         return Future.sync(() {
//             //           return "";
//             //         });
//             //       },
//             //       videoPathBuilder: () {
//             //         return Future.sync(() {
//             //           return "";
//             //         });
//             //       },
//             //       initialCaptureMode: CaptureMode.video,
//             //     ),
//             //     enablePhysicalButton: true,
//             //     filter: AwesomeFilter.AddictiveRed,
//             //     flashMode: FlashMode.auto,
//             //     aspectRatio: CameraAspectRatios.ratio_16_9,
//             //     previewFit: CameraPreviewFit.fitWidth,
//             //     onMediaTap: (mediaCapture) {
//             //       OpenFile.open(mediaCapture.filePath);
//             //     },
//             //   ),
//             // ),

//             Container(
//       child: FlutterCamera(
//         color: Colors.red,
//       ),
//     ));
//   }
// }
