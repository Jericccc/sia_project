// import 'package:flutter/material.dart';
//
// import 'ocr_speech.dart';
//
//
//
// class Library extends StatefulWidget{
//   const Library({Key? key}) : super(key: key);
//
//   @override
//   State<Library> createState() => _LibraryState();
// }
//
// class _LibraryState extends State<Library>{
//
//   void navigateToOcr(BuildContext context){
//     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//       return Ocr_speechOutput();
//     }));
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//         backgroundColor: Color(0xFF93D9E1),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
//         floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.add),
//           onPressed: () {
//             navigateToOcr(context);
//           },
//         ),
//         body: SafeArea(
//             child: Padding(
//                 padding: const EdgeInsets.all(16),
//
//                 child: Column(children: [
//                   Row (
//                     children: [
//                       Text (
//                         'iRead',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Container(
//                         // decoration: BoxDecoration(
//                         //     color: Color(0xFF7DB7BD),
//                         //     borderRadius: BorderRadius.circular(12),
//                         // ),
//                         child: Icon(
//                           Icons.account_box_rounded,
//                           color: Colors.white,
//
//                         ),
//                       ),
//
//                     ],
//
//                   ),
//
//                 ])
//
//             )
//         ),
//
//     );
//
//   }
// }