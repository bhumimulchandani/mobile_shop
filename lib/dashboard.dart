import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shree_vimal_mobile_dhule/brand_report.dart';
import 'package:shree_vimal_mobile_dhule/colour_listview.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/in_info.dart';
import 'package:shree_vimal_mobile_dhule/in_info_listview.dart';
import 'package:shree_vimal_mobile_dhule/license_screen.dart';
import 'package:shree_vimal_mobile_dhule/model_listview.dart';
import 'package:shree_vimal_mobile_dhule/out_info.dart';
import 'package:shree_vimal_mobile_dhule/out_info_listview.dart';
import 'package:shree_vimal_mobile_dhule/transaction_report.dart';
import 'package:shree_vimal_mobile_dhule/user_screen.dart';

class dashboard extends StatefulWidget {
  String code_id = "";

  dashboard(this.code_id);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  var ob_mysql = mysql_class();
  PageController pageCnt = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    // btn_list_method();
  }

  // void btn_list_method() async {
  //   String query =
  //       // "SELECT id.product_id, pi.product_name, id.color_id, ci.color_name, " +
  //       //     " Sum(case when hd.in_out_type='i' then id.in_qty else -id.in_qty end) as in_qty " +
  //       //     " from in_out_info_det id inner join in_out_info_head as hd on hd.in_id=id.in_id " +
  //       //     " inner join product_info as pi on id.product_id=pi.product_id " +
  //       //     " inner join color_info as ci on id.color_id=ci.color_id " +
  //       //     " Group by product_id, product_name, color_id, color_name";

  //       "SELECT fm_id, fm_name, total_final_price FROM finished_m_mst";

  //   finished_m_mst = await ob_mysql.public_select_data_method(query);

  //   setState(() {});

  //   print("hello");
  //   print(finished_m_mst.length.toString());
  // }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double buttonHeight = screenHeight * 0.22;
    final double buttonWidth = screenWidth * 0.49;

    return Scaffold(
        key: mysql_class.screenKey,
        backgroundColor: Colors.transparent,
        drawer: Drawer(
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bgd_1.jpg"),
                        fit: BoxFit.cover)),
                child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                  DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/logo2.webp',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dashboard,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () {
                      pageCnt.jumpToPage(0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.devices,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Model',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () {
                      pageCnt.jumpToPage(1);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Colour',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () {
                      pageCnt.jumpToPage(2);
                      Navigator.pop(context);
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.supervised_user_circle,
                  //     color: Colors.blue.shade800,
                  //   ),
                  //   title: Text(
                  //     'Account',
                  //     style: TextStyle(
                  //         color: Colors.blue.shade800,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 15),
                  //   ),
                  //   onTap: () {
                  //     pageCnt.jumpToPage(3);
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(
                      Icons.perm_device_information,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Purchase',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () {
                      pageCnt.jumpToPage(3);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.outbond,
                      color: Colors.blue.shade800,
                    ),
                    title: Text(
                      'Sale',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () {
                      pageCnt.jumpToPage(4);
                      Navigator.pop(context);
                    },
                  ),
                  if (mysql_class.admin) ...[
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.blue.shade800,
                      ),
                      title: Text(
                        'Users',
                        style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      onTap: () {
                        pageCnt.jumpToPage(5);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.stacked_bar_chart,
                          color: Colors.blue.shade800),
                      title: Text(
                        'Stock Report',
                        style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      onTap: () async {
                        pageCnt.jumpToPage(6);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.analytics_outlined,
                          color: Colors.blue.shade800),
                      title: Text(
                        'Profit Report',
                        style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      onTap: () async {
                        pageCnt.jumpToPage(7);
                        Navigator.pop(context);
                      },
                    )
                  ],
                  const Divider(height: 2, color: Colors.black),
                  ListTile(
                    leading: Icon(Icons.logout_outlined,
                        color: Colors.blue.shade800),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    onTap: () async {
                      await SharedPreferences.getInstance().then((value) {
                        value.setString('uname', '');
                        value.setString('pswd', '');
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LicenseScreen()));
                      });
                    },
                  ),
                ]))),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageCnt,
          children: [
            // dashboard
            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bgd_1.jpg'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    AppBar(
                      title: const Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      backgroundColor: Colors.blue,
                      iconTheme: const IconThemeData(color: Colors.white),
                    ),
                    Expanded(
                      child: ListView(
                          padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: buttonWidth,
                                        height: buttonHeight,
                                        child: ElevatedButton(
                                            child: Text(
                                              'Purchase',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          in_information('')));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  235, 218, 215, 57),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: buttonWidth,
                                        height: buttonHeight,
                                        child: ElevatedButton(
                                            child: Text(
                                              'Sales',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          out_information('')));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 146, 238, 70),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 3,
                            ),
                            SizedBox(
                              height: buttonHeight,
                              child: ElevatedButton(
                                  child: Text(
                                    'Stock Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BrandRep()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade400,
                                  )),
                            ),
                            const Divider(
                              height: 3,
                            ),
                            SizedBox(
                              height: buttonHeight,
                              child: ElevatedButton(
                                  child: Text(
                                    'Profit Report',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ReportsSreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade400,
                                  )),
                            ),
                          ]),
                    ),
                  ],
                )),
            const model_listview(),
            const colour_listview(),
            // const supplier_listview(),
            const in_listview(),
            const out_listview(),
            const UserScreen(),
            const BrandRep(),
            const ReportsSreen(),
          ],
        ));
  }
}
