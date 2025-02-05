// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pwa_update_listener/pwa_update_listener.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shree_vimal_mobile_dhule/dbservices.dart';
// import 'package:shree_vimal_mobile_dhule/login.dart';

// class LicenseScreen extends StatefulWidget {
//   const LicenseScreen({super.key});

//   @override
//   State<LicenseScreen> createState() => _LicenseScreenState();
// }

// class _LicenseScreenState extends State<LicenseScreen> {
//   TextEditingController keyCnt = TextEditingController();
//   ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

//   void showSnack(String text, Color color, BuildContext context) {
//     Flushbar(
//       backgroundColor: color,
//       messageText: Text(
//         text,
//         style: GoogleFonts.poppins(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       flushbarPosition: FlushbarPosition.BOTTOM,
//       icon: const Icon(
//         Icons.error,
//         size: 25,
//         color: Colors.white,
//       ),
//       animationDuration: const Duration(milliseconds: 300),
//       duration: const Duration(milliseconds: 5000),
//       shouldIconPulse: false,
//     ).show(context);
//   }

// // company selection windows = 1

//   @override
//   Widget build(BuildContext context) {
//     return PwaUpdateListener(
//       onReady: () {
//         reloadPwa();
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xffF8F9FC),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(25),
//                       bottomRight: Radius.circular(25)),
//                   child: Image.asset(
//                     "assets/logo2.webp",
//                     width: double.infinity,
//                   )),
//               const SizedBox(height: 50),
//               Text(
//                 'Enter Licence key',
//                 style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w500, fontSize: 20),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: TextFormField(
//                   controller: keyCnt,
//                   style: GoogleFonts.roboto(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                   textCapitalization: TextCapitalization.characters,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 10),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                     hintText: ' Enter License Key',
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: ValueListenableBuilder<bool>(
//                     valueListenable: isLoading,
//                     builder: (context, loading, child) {
//                       if (loading) {
//                         return const LinearProgressIndicator();
//                       }
//                       return ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 0),
//                             padding: const EdgeInsets.symmetric(vertical: 15),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                             backgroundColor: const Color(0xff2F66F6),
//                           ),
//                           onPressed: () async {
//                             isLoading.value = true;
//                             mysql_class
//                                 .checkLicense(keyCnt.text)
//                                 .then((value) async {
//                               isLoading.value = false;

//                               if (value != null) {
//                                 await SharedPreferences.getInstance()
//                                     .then((value) {
//                                   mysql_class.licenseKey = keyCnt.text;
//                                   value.setString('license', keyCnt.text);
//                                 }).then((value) {
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const loginpage()));
//                                 });
//                               } else {
//                                 showSnack('Invalid License key',
//                                     Colors.red.shade600, context);
//                               }
//                             });
//                           },
//                           child: Text(
//                             'VERIFY',
//                             style: GoogleFonts.roboto(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16),
//                           ));
//                     }),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
