import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/manage_user.dart';
import 'package:shree_vimal_mobile_dhule/modal/app_user.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController searchCnt = TextEditingController();
  List<AppUser> userData = [];
  List<AppUser> tempData = [];
  bool searchActive = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String query = "select * from user_mst ORDER BY username ASC";
    var responseData = await ob_mysql.public_select_data_method(query);
    print(responseData.toList().toString());
    userData = responseData.map((e) => AppUser.fromJson(e)).toList();
    tempData = userData;
    searchData(searchCnt.text);
  }

  searchData(String searchVal) {
    if (searchVal != '') {
      userData = tempData
          .where((element) =>
              element.name!.toLowerCase().contains(searchVal.toLowerCase()))
          .toList();
    } else {
      userData = tempData;
    }
    setState(() {});
  }

  var ob_mysql = mysql_class();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgd_1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: mysql_class.screenKey.currentState!.hasDrawer
              ? IconButton(
                  onPressed: () {
                    mysql_class.screenKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu))
              : null,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white70),
          backgroundColor: Colors.blue,
          // leading: IconButton(
          //   icon: const Icon(Icons.menu),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          // ),
          title: searchActive
              ? fu.TextFormBox(
                  autofocus: true,
                  controller: searchCnt,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  placeholder: ' Search ',
                  decoration: const BoxDecoration(color: Colors.white70),
                  placeholderStyle: const TextStyle(fontSize: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  onChanged: (val) {
                    searchData(val);
                  },
                )
              : Text(
                  'Users (${userData.length})',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchActive = !searchActive;
                  });
                },
                icon: Icon(searchActive ? Icons.close : Icons.search)),
            const SizedBox(width: 10)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            loadData();
          },
          child: ListView.separated(
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.transparent),
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.white70,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageUserScreen(
                                  add: false,
                                  user: userData[index]))).then((value) {
                        if (value ?? false) {
                          loadData();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(userData[index].name!,
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              Chip(
                                  backgroundColor: Colors.blue.shade100,
                                  label: Text(
                                      userData[index].admin! ? 'Admin' : 'User',
                                      style: GoogleFonts.roboto(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)))
                            ],
                          ),
                          // const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.privacy_tip_outlined,
                                size: 21,
                                color: Colors.blue.shade800,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(userData[index].uname!,
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              Icon(
                                Icons.lock,
                                size: 21,
                                color: Colors.blue.shade800,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(userData[index].pswd!,
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green.shade600,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ManageUserScreen(add: true))).then((value) {
                if (value ?? false) {
                  loadData();
                }
              });
            },
            label: const Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
