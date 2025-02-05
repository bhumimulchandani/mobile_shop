// import 'package:flutter/material.dart';
// import 'package:fluent_ui/fluent_ui.dart' as fu;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shree_vimal_mobile_dhule/dbservices.dart';
// import 'package:shree_vimal_mobile_dhule/supplier_info.dart';

// class supplier_listview extends StatefulWidget {
//   const supplier_listview({super.key});

//   @override
//   State<supplier_listview> createState() => _supplier_listviewState();
// }

// class _supplier_listviewState extends State<supplier_listview> {
//   TextEditingController searchCnt = TextEditingController();
//   List supplier_mst = [];
//   List tempData = [];
//   bool searchActive = false;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadData() async {
//     String query =
//         "SELECT supplier_id, accounttype, accountname, mobnumber, address, gstno FROM supplier_mst Order by accountname";
//     supplier_mst = await ob_mysql.public_select_data_method(query);
//     tempData = supplier_mst;
//     searchData(searchCnt.text);
//   }

//   searchData(String searchVal) {
//     if (searchVal != '') {
//       supplier_mst = tempData
//           .where((element) =>
//               element['accountname']
//                   .toLowerCase()
//                   .contains(searchVal.toLowerCase()) ||
//               element['accounttype']
//                   .toLowerCase()
//                   .contains(searchVal.toLowerCase()))
//           .toList();
//     } else {
//       supplier_mst = tempData;
//     }
//     setState(() {});
//   }

//   var ob_mysql = mysql_class();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bgd_1.jpg'), fit: BoxFit.cover)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           leading: mysql_class.screenKey.currentState!.hasDrawer
//               ? IconButton(
//                   onPressed: () {
//                     mysql_class.screenKey.currentState!.openDrawer();
//                   },
//                   icon: const Icon(Icons.menu))
//               : null,
//           titleSpacing: 0,
//           iconTheme: const IconThemeData(color: Colors.white70),
//           backgroundColor: Colors.blue,
//           // leading: IconButton(
//           //   icon: const Icon(Icons.menu),
//           //   onPressed: () {
//           //     Scaffold.of(context).openDrawer();
//           //   },
//           // ),
//           title: searchActive
//               ? fu.TextFormBox(
//                   autofocus: true,
//                   controller: searchCnt,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   placeholder: ' Search ',
//                   decoration: const BoxDecoration(color: Colors.white70),
//                   placeholderStyle: const TextStyle(fontSize: 15),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                   onChanged: (val) {
//                     searchData(val);
//                   },
//                 )
//               : Text(
//                   'Account List (${supplier_mst.length})',
//                   style: const TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     searchActive = !searchActive;
//                   });
//                 },
//                 icon: Icon(searchActive ? Icons.close : Icons.search)),
//             const SizedBox(width: 10)
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: () async {
//             loadData();
//           },
//           child: ListView.separated(
//               separatorBuilder: (context, index) =>
//                   const Divider(height: 1, color: Colors.transparent),
//               itemCount: supplier_mst.length,
//               itemBuilder: (context, index) {
//                 return Material(
//                   color: Colors.white70,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => supplier_information(
//                                       supplier_mst[index]['supplier_id'])))
//                           .then((value) {
//                         if (value != null) {
//                           loadData();
//                         }
//                       });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(supplier_mst[index]['accountname'],
//                                     style: GoogleFonts.roboto(
//                                         color: Colors.blue.shade800,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16)),
//                               ),
//                               Text(supplier_mst[index]['accounttype'],
//                                   style: GoogleFonts.roboto(
//                                       color: Colors.blue.shade800,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16)),
//                             ],
//                           ),
//                           const SizedBox(height: 3),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(supplier_mst[index]['gstno'],
//                                     style: GoogleFonts.roboto(
//                                         color: Colors.blue.shade800,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 16)),
//                               ),
//                               Text(supplier_mst[index]['mobnumber'],
//                                   style: GoogleFonts.roboto(
//                                       color: Colors.blue.shade800,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16)),
//                             ],
//                           ),
//                           const SizedBox(height: 3),
//                           Text(supplier_mst[index]['address'],
//                               textAlign: TextAlign.start,
//                               style: GoogleFonts.roboto(
//                                   color: Colors.blue.shade800,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//             backgroundColor: Colors.green.shade600,
//             icon: const Icon(
//               Icons.add,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => supplier_information('')))
//                   .then((value) {
//                 if (value != null) {
//                   loadData();
//                 }
//               });
//             },
//             label: const Text(
//               'ADD',
//               style: TextStyle(color: Colors.white),
//             )),
//       ),
//     );
//   }
// }
