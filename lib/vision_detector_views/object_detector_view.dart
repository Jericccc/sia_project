import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'camera_view.dart';
import 'painters/object_detector_painter.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts _flutterTts = FlutterTts();

class ObjectDetectorView extends StatefulWidget {
  @override
  State<ObjectDetectorView> createState() => _ObjectDetectorView();
}

class _ObjectDetectorView extends State<ObjectDetectorView> {
  late ObjectDetector _objectDetector;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  String? objectName;
  bool _isPlaying = false;


  // @override
  // void initState() {
  //   super.initState();
  //
  //   _initializeDetector(DetectionMode.stream);
  // }

  @override
  void initState() {
    super.initState();
    _initializeDetector(DetectionMode.stream);

    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
  }




  @override
  void dispose() {
    _canProcess = false;
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          title: 'Object Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
          onScreenModeChanged: _onScreenModeChanged,

          initialDirection: CameraLensDirection.back,
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Row(
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Play button logic
                  if (!_isPlaying && _text != null && _text!.isNotEmpty) {
                    speak(_text!);
                    _isPlaying = true;
                  }
                },
                child: Icon(Icons.play_arrow),
              ),
              SizedBox(width: 16.0),
              FloatingActionButton(
                onPressed: () {
                  // Pause button logic
                  flutterTts.pause();
                  _isPlaying = false;
                },
                child: Icon(Icons.pause),
              ),
            ],
          ),
        ),
      ],
    );
  }







  void _onScreenModeChanged(ScreenMode mode) {
    switch (mode) {
      case ScreenMode.gallery:
        _initializeDetector(DetectionMode.single);

        return;

      case ScreenMode.liveFeed:
        _initializeDetector(DetectionMode.stream);
        return;
    }
  }

  void _initializeDetector(DetectionMode mode) async {
    print('Set detector in mode: $mode');


    // initialize FlutterTTS
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);


    // uncomment next lines if you want to use the default model
    // final options = ObjectDetectorOptions(
    //     mode: mode,
    //     classifyObjects: true,
    //     multipleObjects: true);
    // _objectDetector = ObjectDetector(options: options);

    // uncomment next lines if you want to use a local model
    // make sure to add tflite model to assets/ml
    final path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    // uncomment next lines if you want to use a remote model
    // make sure to add model to firebase
    // final modelName = 'bird-classifier';
    // final response =
    //     await FirebaseObjectDetectorModelManager().downloadModel(modelName);
    // print('Downloaded: $response');
    // final options = FirebaseObjectDetectorOptions(
    //   mode: mode,
    //   modelName: modelName,
    //   classifyObjects: true,
    //   multipleObjects: true,
    // );
    // _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final objects = await _objectDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = ObjectDetectorPainter(
          objects,
          inputImage.inputImageData!.imageRotation,
          inputImage.inputImageData!.size);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Objects found: ${objects.length}\n\n';
      for (final object in objects) {
        text += 'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
       objectName = '${object.labels.map((e) => e.text)}';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;


      // Speak the text using FlutterTTS
      await _flutterTts.speak(text);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}

Future<void> speak(String text) async {
  await flutterTts.setLanguage('en-US');
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.speak(text);
}