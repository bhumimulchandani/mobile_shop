import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shree_vimal_mobile_dhule/dashboard.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:intl/intl.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpage();
}

class _loginpage extends State<loginpage> {
  var ob_mysql = mysql_class();
  bool _isHidden = true;

  static int USER_ID = 0;
  static bool admin = false;

  TextEditingController usernameCnt = TextEditingController();
  TextEditingController passwordCnt = TextEditingController();

  seePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  initState() {
    super.initState();
    load_data();
  }

  load_data() async {
    if (mysql_class.conn_yn == 0) {
      await mysql_class.getConnection_method();
    }

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
              ));
    }
  }

  login_method(BuildContext context) async {
    String username = usernameCnt.text;
    String userpassword = passwordCnt.text;

    if (username.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter User Name ", "Ok");
      return;
    }

    if (userpassword.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Password", "Ok");
      return;
    }

    String QUERY = "SELECT * FROM user_mst WHERE username='" +
        username +
        "' AND userpassword='" +
        userpassword +
        "'";

    var aa = await ob_mysql.public_select_data_method(QUERY);

    if (aa.length == 0) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Stop", "Invalid username or password", "Ok");
      return;
    }

    mysql_class.user_id = int.parse(aa[0]["user_id"].toString());
    mysql_class.admin = aa[0]["user_type"].toString() == 'A';
    SharedPreferences.getInstance().then((value) {
      value.setString('uname', usernameCnt.text);
      value.setString('pswd', passwordCnt.text);
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => dashboard("")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgd_1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'User Login',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.blue),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: usernameCnt,
                    decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10)),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: passwordCnt,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10)),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ), // suffix: InkWell(
                  //   onTap: seePassword,
                  //   child: Icon(
                  //     _isHidden
                  //         ? Icons.visibility_off
                  //         : Icons.visibility,
                  //   ),
                  // ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mysql_class.licenseInfo!.expiryDate!
                            .isAfter(DateTime.now())) {
                          login_method(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue),
                      child: const Text('Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
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
}
