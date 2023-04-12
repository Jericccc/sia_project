// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// import 'nlp_detector_views/entity_extraction_view.dart';
// import 'nlp_detector_views/language_identifier_view.dart';
// import 'nlp_detector_views/language_translator_view.dart';
// import 'nlp_detector_views/smart_reply_view.dart';
// import 'vision_detector_views/barcode_scanner_view.dart';
// import 'vision_detector_views/digital_ink_recognizer_view.dart';
// import 'vision_detector_views/face_detector_view.dart';
// import 'vision_detector_views/label_detector_view.dart';
// import 'vision_detector_views/object_detector_view.dart';
// import 'vision_detector_views/pose_detector_view.dart';
// import 'vision_detector_views/selfie_segmenter_view.dart';
// import 'vision_detector_views/text_detector_view.dart';
//
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// List<CameraDescription> cameras = [];
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   cameras = await availableCameras();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }
//
//
// class Home extends StatelessWidget {
//
//
//
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
//
//
// }




import 'dart:async';
import 'dart:developer';

import 'package:example/librarypage.dart';
import 'package:example/translatorpage.dart';
import 'package:example/ocr_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:flutter_tts/flutter_tts.dart';


final FlutterTts flutterTts = FlutterTts();


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iRead',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Library(),

    );
  }
}


//simple with next button
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My App'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Ocr_speechOutput()),
//             );
//           },
//           child: Text('Next'),
//         ),
//       ),
//     );
//   }
// }


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'iRead',)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF93D9E1),
      body: Container(
        margin: const EdgeInsets.only(top: 170.0),
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset('assets/logoiread7.png', height: 250,),
            const SizedBox(height: 250,),
          ],
        ),
      ),
    );
  }
}


//need the user usage
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {


  void navigateToOcr(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Ocr_speechOutput();
    }));
    }



  String text = "";
  final StreamController<String> controller = StreamController<String>();

  final FlutterTts flutterTts = FlutterTts();

  void setText(value) async {
    controller.add(value);
    await flutterTts.speak(value);
  }

  @override
  void dispose() {
    flutterTts.stop();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navigateToOcr(context);
          },
          child: Text('Go to OCR page'),
        ),
      ),
    );
  }
}







// class _MyHomePageState extends State<MyHomePage> {
//   String text = "";
//   final StreamController<String> controller = StreamController<String>();
//
//   final FlutterTts flutterTts = FlutterTts();
//
//   void setText(value) async {
//     controller.add(value);
//     await flutterTts.speak(value);
//   }
//
//
//   @override
//   void dispose() {
//     flutterTts.stop();
//     controller.close();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text(
//               widget.title,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(top: 50.0),
//                 child: ScalableOCR(
//                     paintboxCustom: Paint()
//                       ..style = PaintingStyle.stroke
//                       ..strokeWidth = 4.0
//                       ..color = const Color.fromARGB(153, 102, 160, 241),
//                     boxLeftOff: 5,
//                     boxBottomOff: 2.5,
//                     boxRightOff: 5,
//                     boxTopOff: 2.5,
//                     boxHeight: MediaQuery.of(context).size.height / 3,
//                     getRawData: (value) {
//                       inspect(value);
//                     },
//                     getScannedText: (value) {
//                       setText(value);
//                     }),
//               ),
//               StreamBuilder<String>(
//                 stream: controller.stream,
//                 builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   return Result(text: snapshot.data != null ? snapshot.data! : "");
//                 },
//               )
//             ],
//           ),
//         ));
//   }
// }






//orig
// class Result extends StatefulWidget {
//   const Result({
//     Key? key,
//     required this.text,
//   }) : super(key: key);
//
//   final String text;
//
//   @override
//   _ResultState createState() => _ResultState();
// }
//
// class _ResultState extends State<Result> {
//   String _language = 'en-US';
//
//  @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("Readed text: ${widget.text}"),
//         // ElevatedButton(
//         //   onPressed: () {
//         //     setState(() {
//         //       _language = _language == 'en-US' ? 'tl-PH' : 'en-US';
//         //     });
//         //   },
//         //   child: Text(_language == 'en-US' ? 'Switch to Tagalog' : 'Switch to English'),
//         // ),
//       ],
//     );
//   }
//
//   Future<void> speak(String text) async {
//     await flutterTts.setLanguage(_language);
//     await flutterTts.setPitch(1.0);
//     await flutterTts.setSpeechRate(0.5);
//     await flutterTts.speak(text);
//   }
// }
