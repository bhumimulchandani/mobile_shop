import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shree_vimal_mobile_dhule/dashboard.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:intl/intl.dart';
import 'package:shree_vimal_mobile_dhule/license_screen.dart';
import 'package:shree_vimal_mobile_dhule/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) async {
      if (value.getString('license') != null &&
          value.getString('uname') != null &&
          value.getString('pswd') != null) {
        if (mysql_class.conn_yn == 0) {
          await mysql_class.getConnection_method();
        }

        // check license
        await mysql_class.checkLicense('');
        if (mysql_class.licenseInfo != null &&
            mysql_class.licenseInfo!.expiryDate!.isBefore(DateTime.now())) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text('License Expired'),
                    content: Text(
                        'Your license expired from ${DateFormat('dd-MM-yyyy').format(mysql_class.licenseInfo!.expiryDate!)}'),
                  )).then((val) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LicenseScreen()));
            return;
          });
        }

        // check username & pswd
  String username =value.getString('uname')??'';
    String userpassword = value.getString('pswd')??'';

    String QUERY = "SELECT * FROM user_mst WHERE username='" +
        username +
        "' AND userpassword='" +
        userpassword +
        "'";

    var aa = await mysql_class().public_select_data_method(QUERY);

    if (aa.length == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const loginpage()));
      return;
    }

    mysql_class.user_id = int.parse(aa[0]["user_id"].toString());
    mysql_class.admin = aa[0]["user_type"].toString() == 'A';
    SharedPreferences.getInstance().then((value) {
      value.setString('uname', username);
      value.setString('pswd', userpassword);
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => dashboard("")));
  


      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>  const LicenseScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FC),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Image.asset(
                "assets/logo2.webp",
              ),
            ),
            const Center(child: fl.ProgressBar()),
          ],
        ),
      ),
    );
  }
}
