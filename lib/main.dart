import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'nlp_detector_views/entity_extraction_view.dart';
import 'nlp_detector_views/language_identifier_view.dart';
import 'nlp_detector_views/language_translator_view.dart';
import 'nlp_detector_views/smart_reply_view.dart';
import 'vision_detector_views/barcode_scanner_view.dart';
import 'vision_detector_views/digital_ink_recognizer_view.dart';
import 'vision_detector_views/face_detector_view.dart';
import 'vision_detector_views/label_detector_view.dart';
import 'vision_detector_views/object_detector_view.dart';
import 'vision_detector_views/pose_detector_view.dart';
import 'vision_detector_views/selfie_segmenter_view.dart';
import 'vision_detector_views/text_detector_view.dart';

import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
List<CameraDescription> cameras = [];


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      child: Text(
                        "Snap and Go",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w800,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Text Recognition made Simple",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
                  if (textScanning) const CircularProgressIndicator(),
                  if (!textScanning && imageFile == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, spreadRadius: 5),
                          ],
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  if (imageFile != null) Image.file(File(imageFile!.path)),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          fixedSize: const Size(50, 50),
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.blue[600]!),
                          ),
                        ),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Icon(
                          Icons.image_search,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          fixedSize: const Size(75, 75),
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.blue[600]!),
                          ),
                        ),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          fixedSize: const Size(50, 50),
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.blue[600]!),
                          ),
                        ),
                        onPressed: () {
                          imageFile = null;
                          scannedText = "";
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Translated Data",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[600]),
                  ),
                  scannedText == ""
                      ? Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "No text found",
                        style: const TextStyle(
                            fontSize: 15, fontFamily: "Inter"),
                      ),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        scannedText,
                        style: const TextStyle(
                            fontSize: 20, fontFamily: "Inter"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
         //setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      // setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    // setState(() {});
  }

  @override
  void initState() {
     //super.initState();
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('iRead'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   CustomCard('Text Recognition', TextRecognizerView()),
//                   // ExpansionTile(
//                   //   title: const Text('Vision APIs'),
//                   //   children: [
//                   //     // CustomCard('Barcode Scanning', BarcodeScannerView()),
//                   //     // CustomCard('Face Detection', FaceDetectorView()),
//                   //     // CustomCard('Image Labeling', ImageLabelView()),
//                   //     // CustomCard('Object Detection', ObjectDetectorView()),
//                   //    // CustomCard('Text Recognition', TextRecognizerView()),
//                   //     // CustomCard('Digital Ink Recognition', DigitalInkView()),
//                   //     // CustomCard('Pose Detection', PoseDetectorView()),
//                   //     // CustomCard('Selfie Segmentation', SelfieSegmenterView()),
//                   //   ],
//                   // ),
//                   // SizedBox(
//                   //   height: 20,
//                   // ),
//                   // ExpansionTile(
//                   //   title: const Text('Natural Language APIs'),
//                   //   children: [
//                   //     CustomCard('Language ID', LanguageIdentifierView()),
//                   //     CustomCard(
//                   //         'On-device Translation', LanguageTranslatorView()),
//                   //     CustomCard('Smart Reply', SmartReplyView()),
//                   //     CustomCard('Entity Extraction', EntityExtractionView()),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomCard extends StatelessWidget {
//   final String _label;
//   final Widget _viewPage;
//   final bool featureCompleted;
//
//   const CustomCard(this._label, this._viewPage, {this.featureCompleted = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         tileColor: Theme.of(context).primaryColor,
//         title: Text(
//           _label,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onTap: () {
//           if (!featureCompleted) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content:
//                     const Text('This feature has not been implemented yet')));
//           } else {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => _viewPage));
//           }
//         },
//       ),
//     );
//   }
}

