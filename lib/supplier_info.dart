// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:fluent_ui/fluent_ui.dart' as fu;
// import 'package:flutter/material.dart' as a;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shree_vimal_mobile_dhule/dbservices.dart';
// import 'package:image_picker/image_picker.dart';

// class supplier_information extends StatefulWidget {
//   String main_id = "";
//   String? accountType;

//   supplier_information(this.main_id, {this.accountType});

//   @override
//   State<supplier_information> createState() => _supplier_informationState();
// }

// class _supplier_informationState extends State<supplier_information> {
//   final ImagePicker picker = ImagePicker();
//   XFile? customerPhoto;
//   String? customerNetworkImage;

//   var ob_mysql = mysql_class();

//   final List<String> accountTypes = ['Customer', 'Supplier'];
//   String? selectedAccountType;

//   TextEditingController accountnameCnt = TextEditingController();
//   TextEditingController mobnumberCnt = TextEditingController();
//   TextEditingController addressCnt = TextEditingController();
//   TextEditingController gstnoCnt = TextEditingController();

//   TextEditingController add_modify_Cnt = TextEditingController(text: "ADD");

//   TextStyle formHeaderStyle = GoogleFonts.manrope(
//     fontSize: 16,
//     color: a.Colors.blue.shade900,
//     fontWeight: FontWeight.w600,
//   );

//   @override
//   void initState() {
//     super.initState();

//     load_data();
//   }

//   void load_data() async {
//     setState(() {});
//     if (widget.main_id != "") {
//       get_data_method_by_id();
//     } else if (widget.accountType != null) {
//       selectedAccountType = widget.accountType!;
//     }
//   }

//   void save_and_update_button_method() async {
//     if (await save_data_alert_method(context) == 1) {
//       return;
//     }

//     if (customerPhoto != null) {
//       customerNetworkImage = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//       mysql_class.uploadImg(customerPhoto!.path, customerNetworkImage!);
//     }

//     String acc_name = accountnameCnt.text.replaceAll("'", "''");
//     String mob_number = mobnumberCnt.text.replaceAll("'", "''");
//     String add = addressCnt.text.replaceAll("'", "''");
//     String gst_no = gstnoCnt.text.replaceAll("'", "''");
//     String selectedactype = selectedAccountType.toString();

//     String query =
//         "insert into supplier_mst(accounttype, accountname, mobnumber, address, gstno, image) values('$selectedactype', '$acc_name','$mob_number','$add','$gst_no', '$customerNetworkImage')";

//     if (widget.main_id != "") {
//       query =
//           "update supplier_mst set accounttype='$selectedactype', accountname='$acc_name', mobnumber='$mob_number', address='$add', gstno='$gst_no',image='$customerNetworkImage' where supplier_id='${widget.main_id}'";
//     }

//     var status = await ob_mysql.public_insert_update_delete_data_method(query);
//     if (status != 'success') {
//       await mysql_class.show_confirmation_dialog_box(
//           context, "Error occurred!", status, "Ok");
//       return;
//     }
//     // pop with customer info
//     if (widget.main_id != "") {
//       List<String> customerData = [
//         widget.main_id,
//         selectedAccountType!,
//         accountnameCnt.text,
//         mobnumberCnt.text
//       ];
//       Navigator.pop(context, customerData);
//     } else {
//       List<String> customerData = [
//         mysql_class.lastInsertID,
//         selectedAccountType!,
//         accountnameCnt.text,
//         mobnumberCnt.text
//       ];
//       Navigator.pop(context, customerData);
//     }
//   }

//   void delete_button_method(BuildContext context) async {
//     if (widget.main_id != "") {
//       bool confirmDelete = await mysql_class.show_confirmation_dialog_box(
//           context,
//           "Confirmation",
//           "Do you want to delete this record?",
//           "yes_no");

//       // If the user confirms deletion
//       if (confirmDelete) {
//         var data_dt = await ob_mysql.public_select_data_method(
//             "select supplier_id as existance_id from in_info_mst where supplier_id=${widget.main_id}");
//         if (data_dt.length > 0) {
//           await mysql_class.show_confirmation_dialog_box(
//               context, "Stop", "This is Used in Some Entries", "Ok");
//           return;
//         }
//         var datadt = await ob_mysql.public_select_data_method(
//             "select customer_id as existance_id from out_info_mst where customer_id=${widget.main_id}");
//         if (datadt.length > 0) {
//           await mysql_class.show_confirmation_dialog_box(
//               context, "Stop", "This is Used in Some Entries", "Ok");
//           return;
//         }

//         String query =
//             " delete from supplier_mst where supplier_id='${widget.main_id}'";

//         var status =
//             await ob_mysql.public_insert_update_delete_data_method(query);
//         if (status != 'success') {
//           await mysql_class.show_confirmation_dialog_box(
//               context, "Error occurred!", status, "Ok");
//           return;
//         }

//         Navigator.pop(context, true);
//       }
//     }
//   }

//   Future<int> save_data_alert_method(BuildContext context) async {
//     if (selectedAccountType == null || selectedAccountType!.isEmpty) {
//       await mysql_class.show_confirmation_dialog_box(
//           context, "Alert", "Please Select Account Type", "Ok");
//       return 1;
//     }
//     if (accountnameCnt.text.isEmpty) {
//       await mysql_class.show_confirmation_dialog_box(
//           context, "Required", "Please Enter Account Name", "Ok");
//       return 1;
//     }
//     if (mobnumberCnt.text.isEmpty) {
//       await mysql_class.show_confirmation_dialog_box(
//           context, "Required", "Please Enter Mobile Number", "Ok");
//       return 1;
//     }
//     if (addressCnt.text.isEmpty) {
//       await mysql_class.show_confirmation_dialog_box(
//           context, "Required", "Please Enter Address", "Ok");
//       return 1;
//     }
//     // if (gstnoCnt.text.isEmpty) {
//     //   await mysql_class.show_confirmation_dialog_box(
//     //       context, "Required", "Please Enter Gst No", "Ok");
//     //   return 1;
//     // }

//     return 0;
//   }

//   void reset_data() {
//     this.setState(() {
//       accountnameCnt.clear();
//       mobnumberCnt.clear();
//       addressCnt.clear();
//       gstnoCnt.clear();
//       selectedAccountType = "";

//       widget.main_id = "";
//       add_modify_Cnt.text = "Add";
//     });
//   }

//   void get_data_method_by_id() async {
//     String query =
//         "SELECT * FROM supplier_mst WHERE supplier_id='${widget.main_id}' Order by accountname";

//     var data_dt = await ob_mysql.public_select_data_method(query);

//     selectedAccountType = data_dt[0]["accounttype"].toString();
//     accountnameCnt.text = data_dt[0]["accountname"].toString();
//     mobnumberCnt.text = data_dt[0]["mobnumber"].toString();
//     addressCnt.text = data_dt[0]["address"].toString();
//     gstnoCnt.text = data_dt[0]["gstno"].toString();
//     customerNetworkImage = data_dt[0]["image"].toString();

//     add_modify_Cnt.text = "Modify";

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bgd_1.jpg'), fit: BoxFit.cover)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           titleSpacing: 0,
//           iconTheme: const IconThemeData(color: Colors.white),
//           backgroundColor: Colors.blue,
//           title: Text(
//             'Account Info : ${add_modify_Cnt.text}',
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 fu.InfoLabel(
//                   label: "Account Type",
//                   labelStyle:
//                       formHeaderStyle.copyWith(color: Colors.blue.shade800),
//                   child: DropdownButtonFormField<String>(
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       isDense: true,
//                       filled: true,
//                       fillColor: Colors.white70,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 12),
//                     ),
//                     dropdownColor: Colors.grey.shade200,
//                     value: selectedAccountType,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedAccountType = newValue;
//                       });
//                     },
//                     items: accountTypes.map((String accountType) {
//                       return DropdownMenuItem<String>(
//                         value: accountType,
//                         child: Text(accountType,
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.blue.shade900,
//                                 fontWeight: FontWeight.w600)),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 fu.InfoLabel(
//                   label: "Account Name",
//                   labelStyle:
//                       formHeaderStyle.copyWith(color: Colors.blue.shade800),
//                   child: a.TextFormField(
//                     textCapitalization: TextCapitalization.words,
//                     decoration: mysql_class.searchableDecoration,
//                     autofocus: true,
//                     controller: accountnameCnt,
//                     style: formHeaderStyle,
//                     textInputAction: TextInputAction.next,
//                   ),
//                 ),
//                 fu.InfoLabel(
//                   label: "Mobile No",
//                   labelStyle:
//                       formHeaderStyle.copyWith(color: Colors.blue.shade800),
//                   child: a.TextFormField(
//                     textCapitalization: TextCapitalization.words,
//                     decoration: mysql_class.searchableDecoration,
//                     autofocus: true,
//                     controller: mobnumberCnt,
//                     style: formHeaderStyle,
//                     textInputAction: TextInputAction.next,
//                   ),
//                 ),
//                 fu.InfoLabel(
//                   label: "Address",
//                   labelStyle:
//                       formHeaderStyle.copyWith(color: Colors.blue.shade800),
//                   child: a.TextFormField(
//                     textCapitalization: TextCapitalization.words,
//                     decoration: mysql_class.searchableDecoration,
//                     autofocus: true,
//                     controller: addressCnt,
//                     style: formHeaderStyle,
//                     textInputAction: TextInputAction.next,
//                   ),
//                 ),
//                 fu.InfoLabel(
//                   label: "Gst No",
//                   labelStyle:
//                       formHeaderStyle.copyWith(color: Colors.blue.shade800),
//                   child: a.TextFormField(
//                     textCapitalization: TextCapitalization.words,
//                     decoration: mysql_class.searchableDecoration,
//                     autofocus: true,
//                     controller: gstnoCnt,
//                     style: formHeaderStyle,
//                   ),
//                 ),
//                 // if (selectedAccountType == 'Customer') ...[
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 150,
//                   child: Material(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: const BorderSide(color: Colors.black12)),
//                     color: Colors.grey.shade200,
//                     child: customerPhoto != null
//                         ? Image.file(File(customerPhoto!.path))
//                         : customerNetworkImage != null &&
//                                 customerNetworkImage != ''
//                             ? Image.network(
//                                 mysql_class.imageURL + customerNetworkImage!,
//                                 errorBuilder: (context, obj, error) =>
//                                     const Center(
//                                         child: Text('Error loading Image')),
//                               )
//                             : Column(
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                         child: Text('Select Image',
//                                             style: GoogleFonts.poppins(
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black54))),
//                                   ),
//                                   Divider(
//                                       height: 1, color: Colors.grey.shade400),
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                           child: TextButton(
//                                               style: TextButton.styleFrom(
//                                                   minimumSize: Size.zero,
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       vertical: 15,
//                                                       horizontal: 5),
//                                                   shape: RoundedRectangleBorder(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               3))),
//                                               onPressed: () async {
//                                                 await picker
//                                                     .pickImage(
//                                                         source:
//                                                             ImageSource.gallery)
//                                                     .then((val) {
//                                                   if (val != null) {
//                                                     setState(() {
//                                                       customerPhoto = val;
//                                                     });
//                                                   }
//                                                 });
//                                               },
//                                               child: Text(
//                                                 'Choose Photo',
//                                                 style: GoogleFonts.poppins(
//                                                     fontSize: 14.5,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ))),
//                                       Expanded(
//                                           child: TextButton(
//                                               style: TextButton.styleFrom(
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             3)),
//                                                 minimumSize: Size.zero,
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 15,
//                                                         horizontal: 5),
//                                               ),
//                                               onPressed: () async {
//                                                 await picker
//                                                     .pickImage(
//                                                         maxHeight: 1200,
//                                                         maxWidth: 1200,
//                                                         source:
//                                                             ImageSource.camera)
//                                                     .then((val) {
//                                                   if (val != null) {
//                                                     setState(() {
//                                                       customerPhoto = val;
//                                                     });
//                                                   }
//                                                 });
//                                               },
//                                               child: Text(
//                                                 'Capture Photo',
//                                                 style: GoogleFonts.poppins(
//                                                     fontSize: 14.5,
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                               ))),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                   ),
//                 ),
//                 // ],
//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           save_and_update_button_method();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           backgroundColor: Colors.blue,
//                         ),
//                         child: Text(
//                           widget.main_id == '' ? 'Save' : 'Update',
//                           style: GoogleFonts.poppins(
//                               color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     if (widget.main_id != '') ...[
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             delete_button_method(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             backgroundColor: Colors.red.shade600,
//                           ),
//                           child: Text('Delete',
//                               style: GoogleFonts.poppins(
//                                   color: Colors.white, fontSize: 16)),
//                         ),
//                       )
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
