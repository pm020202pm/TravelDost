// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:transport/Components/home_item_list.dart';
// import 'package:transport/Components/user_card.dart';
// import '../Components/my_request_card.dart';
// import '../constants.dart';
//
//
// class CatalogueTab extends StatefulWidget {
//   const CatalogueTab({super.key});
//   @override
//   State<CatalogueTab> createState() => _CatalogueTabState();
// }
//
// class _CatalogueTabState extends State<CatalogueTab> {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           MyRequestCard(),
//           const SizedBox(height: 15,),
//           Padding(
//             padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//             child: (isMyCardExpanded)? Text('Others Request'): Text('hjg'),
//           ),
//           (isMyCardExpanded==false)? HomeList(): Container()
//
//         ],
//       ),
//     );
//   }
// }

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:transport/Components/Image_card.dart';
// import 'package:transport/Components/button.dart';
// import 'package:transport/Components/custom_textfield.dart';
// import 'package:transport/Components/scrollable_list.dart';
// import '../Components/home_item_list.dart';
// import '../constants.dart';
// import '../pages/home_page.dart';
//
// class MyRequestCard extends StatefulWidget {
//   MyRequestCard({Key? key}) : super(key: key);
//   @override
//   State<MyRequestCard> createState() => _MyRequestCardState();
// }
//
// class _MyRequestCardState extends State<MyRequestCard> {
//   String name = '';
//   String time = '';
//   String imageUrl = '';
//   bool isDeleted=false;
//   String? _selectedItem='Auto';
//   late String deleteID;
//   bool isSmallExpanded = true;
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();
//
//   @override
//   void initState() {
//     getDocumentIdByFieldValue();
//     super.initState();
//   }
//   /////TO DELETE A REQUEST
//   Future<void> deleteCard(String documentId) async {
//     FirebaseFirestore.instance.collection('Users').doc(documentId).delete().then((value) {
//       print('CARD DELETED SUCCESSFULLY');
//     }).catchError((error) {
//       print('FAILED TO DELETE CARD: $error');
//     });
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('requests').where('receiverUid', isEqualTo: userUid).get();
//     querySnapshot.docs.forEach((document) {
//       document.reference.delete();
//     });
//     QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance.collection('pending').where('receiverUid', isEqualTo: userUid).get();
//     querySnapshot1.docs.forEach((document) {
//       document.reference.delete();
//     });
//   }
//
//   /////RETRIEVING DATA OF A SPECIFIC DOCUMENT
//   Future<void> getDocumentIdByFieldValue() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').where('Uid', isEqualTo: userUid).get();
//     if (snapshot.size > 0) {
//       DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(snapshot.docs[0].id).get();
//       if (doc.exists) {
//         setState(() {
//           name = userName;
//           time = '${doc.get('hours')} : ${doc.get('minute')} ${doc.get('pmam')}';
//           deleteID = doc.id;
//         });
//       }
//       else {
//         print('Document with ID does not exist.');
//       }
//     }
//     else {
//       print('no_doc');
//     }
//   }
//
//   /////SUBMIT DETAILS
//   Future<void> submitDetails() async {
//     await FirebaseFirestore.instance.collection('Users').add({
//       'Name': userName,
//       'Uid': userUid,
//       'imageUrl' : userImageUrl,
//       'isRequested': false,
//       'mode' : _selectedItem,
//       'hours' : hours[selectedHour], 'minute' : minutes[selectedMinute], 'pmam' : pmam[selectedPmAm],
//       'from' : fromController.text,  'to' : toController.text,
//       'message' : detailsController.text,
//
//     }).then((value) => print("User added")).catchError((error) => print("Failed to add user: $error"));
//     fromController.clear();
//     toController.clear();
//     detailsController.clear();
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyHomePage()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         fit: StackFit.loose,
//         alignment: Alignment.topLeft,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//                 child: Text('My Request'),
//               ),
//               Flexible(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: AnimatedContainer(
//                       width: screenSize.width*0.9,
//                       height: (isMyCardExpanded)? screenSize.height*0.45:90,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(20)
//                       ),
//                       duration: const Duration(milliseconds: 200),
//                       child: SingleChildScrollView(
//                         child: (name == '')
//                             ? SizedBox(
//                           width: 0.9*screenSize.width,
//                           child: (isMyCardExpanded==false)
//                               ? InkWell(
//                             onTap: () {
//                               setState(() {
//                                 isMyCardExpanded = true;
//                               });
//                               print('$isMyCardExpanded');
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 0.9*screenSize.width,
//                               height: 90,
//                               child: const Column(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Icon(Icons.add),
//                                   Text('Create a new request')
//                                 ],
//                               ),
//                             ),
//                           )
//                               : Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     ////SET TIME WIDGET
//                                     Container(
//                                       height: 96,
//                                       width: 0.9*screenSize.width-110,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(15),
//                                           color: Colors.grey[300]
//                                       ),
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Opacity(
//                                             opacity: .5,
//                                             child: Container(
//                                               height: 32,
//                                               width: 0.9*screenSize.width-135,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey[500],
//                                                   borderRadius: BorderRadius.circular(50)
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 71,
//                                             width: 180,
//                                             child: Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                                 ScrollHour(),
//                                                 const SizedBox(width: 20, child: Text(' :', style: TextStyle(fontSize: 24),),),
//                                                 ScrollMinute(),
//                                                 const SizedBox(width: 8,),
//                                                 ScrollPmAm(),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     ////SET VEHICLE WIDGET
//                                     Stack(
//                                       alignment: Alignment.topCenter,
//                                       children: [
//                                         Container(
//                                           alignment: Alignment.center,
//                                           height: 96,
//                                           width: 85,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(15),
//                                               color: Colors.grey[300]
//                                           ),
//                                           child:Column(
//                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Container(
//                                                   alignment: Alignment.center,
//                                                   width: 70,
//                                                   height: 20,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.grey[400],
//                                                     borderRadius: BorderRadius.circular(20),
//                                                   ),
//                                                   child: const Text('Travel mode', style: TextStyle(fontSize: 11),)
//                                               ),
//                                               DropdownButton<String>(
//                                                 borderRadius: BorderRadius.circular(20),
//                                                 iconSize: 0,
//                                                 dropdownColor: Colors.grey[100],
//                                                 value: _selectedItem,
//                                                 elevation: 1,
//                                                 onChanged: (String? newValue) {
//                                                   setState(() {
//                                                     _selectedItem = newValue;
//                                                   });
//                                                   print(_selectedItem);
//                                                 },
//                                                 items: <String>['Auto', 'Bus', 'Car', 'Train', 'Flight'].map((String value) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: value,
//                                                     child: Container(
//                                                         height: 50,
//                                                         width: 70,
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(10),
//                                                           color: Colors.grey[200],
//                                                         ),
//                                                         child: Image.asset('assets/$value.png')
//                                                     ),
//                                                   );
//                                                 }).toList(),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20,),
//                                 Row(
//                                   children: [
//                                     Expanded(child: CustomTextField(controller: fromController, obscureText: false, boxHeight: 35, hintText: 'From Place',)),
//                                     const SizedBox(width: 10,),
//                                     Expanded(child: CustomTextField(controller: toController, obscureText: false, boxHeight: 35, hintText: 'To Place',)),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20,),
//                                 TextField(
//                                   maxLines: 2,
//                                   maxLength: 60,
//                                   controller: detailsController,
//                                   decoration: const InputDecoration(
//                                     hintText: 'Add a message (optional)',
//                                     hintStyle: TextStyle(fontSize: 13),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.lightBlue, width: 0,),
//                                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.lightBlue, width: 1,),
//                                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                                     ),
//                                     filled: true,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20,),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Button(
//                                       buttonText: 'Create',
//                                       textColor: Colors.green[900],
//                                       buttonBgColor: Colors.green[100],
//                                       onPressed: ()  async {
//                                         await submitDetails();
//                                         setState(() {
//                                           isMyCardExpanded=false;
//                                         });
//                                       },
//                                       height: 32, width: 70, borderRadius: 15,
//                                       splashColor: Colors.green[200],
//                                     ),
//                                     const SizedBox(width: 10,),
//                                     Button(
//                                       buttonText: 'Cancel' ,
//                                       textColor: Colors.red,
//                                       buttonBgColor: Colors.red[100],
//                                       onPressed: () {
//                                         setState(() {
//                                           isMyCardExpanded = false;
//                                         });
//                                       },
//                                       height: 32, width: 80, borderRadius: 15,
//                                       splashColor: Colors.red[200],
//                                     ),
//                                     const SizedBox(width: 10,),
//                                   ],)
//                               ],
//                             ),
//                           ),
//                         )
//                             : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               ImageCard(height: 70, width: 70, radius: 18, imageProvider: NetworkImage(userImageUrl),),
//                               const SizedBox(width: 20,),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: 0.5* screenSize.width,
//                                     child: Text('Name: $name'),
//                                   ),
//                                   const SizedBox(height: 4,),
//                                   Text('Leaving at $time'),
//                                   const SizedBox(height: 4,),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         height: 30,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(20),
//                                           color: Colors.red[100],
//                                         ),
//                                         child: TextButton(
//                                             onPressed: () {
//                                               deleteCard(deleteID);
//                                               setState(() {
//                                                 name='';
//                                               });
//                                             },
//                                             child: const Text("Delete")),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15,),
//           (isMyCardExpanded==false)? HomeList(): Container()
//         ],
//       ),
//     );
//   }
// }
