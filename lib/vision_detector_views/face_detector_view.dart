import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera_view.dart';
import 'painters/face_detector_painter.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts _flutterTts = FlutterTts();
Timer? _detectionCooldown;


class FaceDetectorView extends StatefulWidget {
  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  bool _isFlashOn = false; // added flash state variable


  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);

      },
      initialDirection: CameraLensDirection.front,

    );
  }


  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);


    // if (faces.isNotEmpty) {
    //   final message = 'Face detected';
    //   await speak(message);
    //
    //   if (_detectionCooldown?.isActive ?? false) {
    //     _detectionCooldown!.cancel();
    //     _detectionCooldown = null;
    //   }
    //   _detectionCooldown = Timer(Duration(seconds: 4), () {
    //     _detectionCooldown = null;
    //   });
    // }

    if (faces.isNotEmpty) {
      final message = 'Face detected';
      await speakWithDelay(message, Duration(seconds: 2));
    }




    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}


Future<void> speak(String message) async {
  await _flutterTts.speak(message);
}

Future<void> speakWithDelay(String message, Duration delay) async {
  await Future.delayed(delay);
  await _flutterTts.speak(message);
}