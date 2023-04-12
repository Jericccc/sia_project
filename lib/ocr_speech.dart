// TODO Implement this library.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:flutter_tts/flutter_tts.dart';


final FlutterTts flutterTts = FlutterTts();


class Ocr_speechOutput extends StatelessWidget {
  const Ocr_speechOutput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iRead',

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyOCRPage(title: 'iRead'),

    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('ocr page'),
    //   ),
    //   body: const Center(
    //     child: Text('ocr'),
    //     home: const MyHomePage(title: 'iRead'),
    //   ),
    // );
  }
}

class MyOCRPage extends StatefulWidget {
  const MyOCRPage({super.key, required this.title});

  final String title;

  @override
  State<MyOCRPage> createState() => _MyOCRPageState();
}



class _MyOCRPageState extends State<MyOCRPage> {
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
      body: Container(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ScalableOCR(
                paintboxCustom: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4.0
                  ..color = const Color.fromARGB(153, 102, 160, 241),
                boxLeftOff: 5,
                boxBottomOff: 2.5,
                boxRightOff: 5,
                boxTopOff: 2.5,
                boxHeight: MediaQuery.of(context).size.height / 3,
                getRawData: (value) {
                  inspect(value);
                },
                getScannedText: (value) {
                  setText(value);
                },
              ),
            ),
            StreamBuilder<String>(
              stream: controller.stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Result(text: snapshot.data != null ? snapshot.data! : "");
              },
            ),
          ],
        ),
      ),
    );
  }
}



class Result extends StatefulWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String _language = 'en-US';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Readed text: ${widget.text}"),
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       _language = _language == 'en-US' ? 'tl-PH' : 'en-US';
        //     });
        //   },
        //   child: Text(_language == 'en-US' ? 'Switch to Tagalog' : 'Switch to English'),
        // ),
      ],
    );
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(_language);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }
}