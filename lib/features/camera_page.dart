import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:test_sample/features/no_permission_screen.dart';
import 'package:test_sample/features/photoPage.dart';
import 'package:test_sample/features/video_page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../themes/color_variables.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  int _currentCameraIndex = 0;
  Timer? _recordingTimer;
  int _recordingDuration = 30;
  ValueNotifier<double> _recordingProgress = ValueNotifier<double>(0.0);
  bool _isRecordingStarted = false;
  List<CameraDescription> cameras = [];
  GlobalKey _record = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    tutorialCoachMark = TutorialCoachMark(
      textStyleSkip: TextStyle(color: ReplyColors.white),
      targets: [
        TargetFocus(
            identify: _record.toString(),
            keyTarget: _record,
            radius: 12,
            shape: ShapeLightFocus.Circle,
            color: ReplyColors.blue50,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                builder: (context, controller) {
                  return Text(
                    "Tap on the button to take pictures\n\n Tap and hold to capture videos",
                    style: TextStyle(color: Colors.white),
                  );
                },
              )
            ])
      ],
      hideSkip: false,

      textSkip: "SKIP", alignSkip: Alignment.topRight,
      paddingFocus: 10, showSkipInLastTarget: true,
      //focusAnimationDuration: Duration(milliseconds: 800),
      opacityShadow: 0.8,

      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {
        log('onClickOverlay: $target');
      },
    );
    Future.delayed(Duration(milliseconds: 560),
        () => tutorialCoachMark!.show(context: context));

    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    if (tutorialCoachMark != null) tutorialCoachMark!.finish();
    super.dispose();
  }

  _initCamera() async {
    try {
      final cameras = await availableCameras();

      for (int i = 0; i < cameras.length; i++) {
        log("${cameras[i].name}"
            "${cameras[i].lensDirection}"
            "${cameras[i].sensorOrientation}");
      }
      // final front = cameras.firstWhere(
      //     (camera) => camera.lensDirection == CameraLensDirection.back);

      _currentCameraIndex = _currentCameraIndex.clamp(0, cameras.length - 1);
      log(_currentCameraIndex.toString());
      final selectedCamera = cameras[_currentCameraIndex];

      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.ultraHigh);
      _cameraController.setFlashMode(FlashMode.always);
      await _cameraController.initialize();
      setState(() => _isLoading = false);
    } catch (e) {
      log(e.toString());
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => NoPermissionScreen(),
      );
      Navigator.pushReplacement(context, route);
    }
  }
//!OG

  // _toggleCamera() async {
  //   if (_isRecording) return;

  //   _recordingTimer?.cancel();
  //   _isRecordingStarted = false;

  //   try {
  //     final cameras = await availableCameras();
  //     _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
  //     _cameraController.dispose();
  //     _initCamera();
  //   } catch (e) {
  //     log("Error:$e");
  //   }
  // }

//Second last
  // _toggleCamera() async {
  //   if (_isRecording) {
  //     try {
  //       cameras = await availableCameras();
  //       _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
  //       _cameraController.dispose();

  //       final selectedCamera = cameras[_currentCameraIndex];
  //       _cameraController =
  //           CameraController(selectedCamera, ResolutionPreset.low);
  //       await _cameraController.initialize();
  //       await _cameraController.prepareForVideoRecording();
  //       await _cameraController.startVideoRecording();

  //       setState(() {});
  //     } catch (e) {
  //       log("Error:$e");
  //     }
  //   } else {
  //     _recordingTimer?.cancel();
  //     _isRecordingStarted = false;

  //     try {
  //       final cameras = await availableCameras();
  //       _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
  //       _cameraController.dispose();
  //       _initCamera();
  //     } catch (e) {
  //       log("Error:$e");
  //     }
  //   }
  // }

//latest
  _toggleCamera() async {
    try {
      final cameras = await availableCameras();

      _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
      final selectedCamera = cameras[_currentCameraIndex];
      // await _cameraController.pauseVideoRecording();
      // await _cameraController.
      // _cameraController.dispose();
      // _initCamera();

      await _cameraController.setDescription(selectedCamera);

      // await _cameraController.resumeVideoRecording();

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Widget buildCameraPreview() {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    );
  }

  // _recordVideo() async {
  //   if (_isRecording) {
  //     _recordingTimer?.cancel();
  //     final file = await _cameraController.stopVideoRecording();
  //     setState(() {
  //       _isRecording = false;
  //       //? to reset the progress circle
  //       _isRecordingStarted = false;
  //       _recordingProgress.value = 0.0;
  //     });

  //     final route = MaterialPageRoute(
  //       fullscreenDialog: true,
  //       builder: (_) => VideoPage(filePath: file.path),
  //     );
  //     Navigator.push(context, route);
  //   } else {
  //     await _cameraController.prepareForVideoRecording();
  //     await _cameraController.startVideoRecording();
  //     setState(() {
  //       _isRecording = true;
  //       _isRecordingStarted = true;
  //       _recordingProgress.value = 0.0;
  //     });

  //     _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //       _recordingProgress.value += 1.0;

  //       if (_recordingProgress.value >= _recordingDuration) {
  //         _recordingTimer?.cancel();
  //         _recordVideo();
  //       }
  //     });
  //   }
  // }

  // _startRecord() async {
  //   await _cameraController.prepareForVideoRecording();
  //   await _cameraController.startVideoRecording();
  //   setState(() {
  //     _isRecording = true;
  //     _isRecordingStarted = true;
  //     _recordingProgress.value = 0.0;
  //   });

  //   _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _recordingProgress.value += 1.0;

  //     if (_recordingProgress.value >= _recordingDuration) {
  //       _recordingTimer?.cancel();
  //       _recordVideo();
  //     }
  //   });
  // }

  // _stopRecord() async {
  //   _recordingTimer?.cancel();
  //   final file = await _cameraController.stopVideoRecording();
  //   setState(() {
  //     _isRecording = false;
  //     //? to reset the progress circle
  //     _isRecordingStarted = false;
  //     _recordingProgress.value = 0.0;
  //   });

  //   final route = MaterialPageRoute(
  //     fullscreenDialog: true,
  //     builder: (_) => VideoPage(filePath: file.path),
  //   );
  //   Navigator.push(context, route);
  // }

//!OG
  _recordVideo() async {
    if (_isRecording) {
      _recordingTimer?.cancel();

      final file = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
        //? to reset the progress circle
        _isRecordingStarted = false;
        _recordingProgress.value = 0.0;
      });
      // Share.shareXFiles([file], text: 'Check out this video!');
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(file: file),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
        _isRecordingStarted = true;
        _recordingProgress.value = 0.0;
      });

      _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        _recordingProgress.value += 1.0;

        if (_recordingProgress.value >= _recordingDuration) {
          _recordingTimer?.cancel();
          _recordVideo();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        // backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          child: GestureDetector(
            onDoubleTap: () {
              _toggleCamera();
              // _cameraController.
            },
            child: Stack(
              fit: StackFit.loose,

              // alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_cameraController),
                // InkWell(
                //   child: Icon(
                //     Icons.lock,
                //     size: 200,
                //   ),
                //   onTap: () {
                //     _cameraController.lockCaptureOrientation();
                //   },
                // ),
                // Positioned(
                //   right: 0,
                //   child: InkWell(
                //     child: Icon(
                //       Icons.lock_open,
                //       size: 200,
                //     ),
                //     onTap: () {
                //       _cameraController.unlockCaptureOrientation();
                //     },
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          key: _record,
                          alignment: Alignment.bottomCenter,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: _recordingProgress,
                                builder: (ctx, value, child) {
                                  return SizedBox(
                                    // height: 60,
                                    // width: 60,
                                    child: Transform.scale(
                                      scale: _isRecording ? 2.5.sp : 1.6.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 6.sp,
                                        value: _isRecordingStarted
                                            ? _recordingProgress.value /
                                                _recordingDuration
                                            : 0.0,
                                        backgroundColor: Colors.grey,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                  );
                                }),
                            //OG
                            Positioned(
                              bottom: 3,
                              child: GestureDetector(
                                  onLongPressUp: () {
                                    log("longpressUp");
                                    _recordVideo();
                                  },
                                  onLongPressStart: (e) {
                                    log("longpressdown");
                                    _recordVideo();
                                  },
                                  onTap: () async {
                                    final file =
                                        await _cameraController.takePicture();
                                    final route = MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (_) => PhotoPage(file: file),
                                    );
                                    Navigator.push(context, route);
                                  },
                                  child: Icon(
                                    _isRecording ? Icons.stop : Icons.circle,
                                    size: 30.sp,
                                  )),
                            ),

                            //     Positioned(
                            //       bottom: 3,
                            //       child: GestureDetector(
                            //           onTapDown: (_) {
                            //             log("onTapDown");

                            //             _startRecord();
                            //           },
                            //           onTapCancel: () {
                            //             log("onTapCnacenle");

                            //             _stopRecord();
                            //           },
                            //           onTapUp: (e) {
                            //             log("onTap");

                            //             _stopRecord();
                            //           },
                            //           child: Icon(
                            //             _isRecording ? Icons.stop : Icons.circle,
                            //             size: 30.sp,
                            //           )),
                            //     ),
                            //   ],
                            // )),

                            // Positioned(
                            //   bottom: 3,
                            //   child: GestureDetector(
                            //       // onLongPress: () {
                            //       //   log("longpress");
                            //       // },
                            //       onLongPressDown: (e) {
                            //         log("longpressDown");
                            //       },
                            //       onLongPressUp: () {
                            //         log("longpressUp");
                            //         _recordVideo();
                            //       },
                            //       onLongPressStart: (e) {
                            //         log("longpressStart");
                            //         _recordVideo();
                            //       },
                            //       // onTapCancel: () {
                            //       //   log("onTapCancell");
                            //       // },
                            //       // onTapUp: (e) {
                            //       //   log("onTapUp");
                            //       //   // _recordVideo();
                            //       // },
                            //       // onTapDown: (e) {
                            //       //   log("onTapDown");
                            //       //   // _recordVideo();
                            //       // },

                            //       child: Icon(
                            //         _isRecording ? Icons.stop : Icons.circle,
                            //         size: 30.sp,
                            //       )),
                            // ),
                          ],
                        )),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 40.w, bottom: 40.h),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () {
                            _toggleCamera();
                          },
                          child: Icon(
                            Icons.sync,
                            size: 30.sp,
                          ))),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
