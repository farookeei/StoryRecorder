import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_sample/features/no_permission_screen.dart';
import 'package:test_sample/features/video_page.dart';

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

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
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
          CameraController(selectedCamera, ResolutionPreset.low);
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

  _toggleCamera() async {
    if (_isRecording) {
      try {
        cameras = await availableCameras();
        _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
        _cameraController.dispose();

        final selectedCamera = cameras[_currentCameraIndex];
        _cameraController =
            CameraController(selectedCamera, ResolutionPreset.low);
        await _cameraController.initialize();
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();

        setState(() {});
      } catch (e) {
        log("Error:$e");
      }
    } else {
      _recordingTimer?.cancel();
      _isRecordingStarted = false;

      try {
        final cameras = await availableCameras();
        _currentCameraIndex = (_currentCameraIndex + 1) % cameras.length;
        _cameraController.dispose();
        _initCamera();
      } catch (e) {
        log("Error:$e");
      }
    }
  }

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

      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
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

//!OG
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: _recordingProgress,
                                builder: (ctx, value, child) {
                                  return SizedBox(
                                    // height: 60,
                                    // width: 60,
                                    child: Transform.scale(
                                      scale: 1.6.sp,
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
                            Positioned(
                              bottom: 3,
                              child: InkWell(
                                  onTap: () => _recordVideo(),
                                  child: Icon(
                                    _isRecording ? Icons.stop : Icons.circle,
                                    size: 30.sp,
                                  )),
                            ),
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
