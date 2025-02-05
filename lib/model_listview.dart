import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/model_info.dart';

class model_listview extends StatefulWidget {
  const model_listview({super.key});

  @override
  State<model_listview> createState() => _model_listviewState();
}

class _model_listviewState extends State<model_listview> {
  TextEditingController searchCnt = TextEditingController();
  List model_mst = [];
  List tempData = [];
  bool searchActive = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String query =
        "SELECT model_id, modelname, brand, discount FROM model_mst Order by brand, modelname";
    model_mst = await ob_mysql.public_select_data_method(query);
    tempData = model_mst;
    searchData(searchCnt.text);
  }

  searchData(String searchVal) {
    if (searchVal != '') {
      model_mst = tempData
          .where((element) =>
              element['modelname']
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element['brand'].toLowerCase().contains(searchVal.toLowerCase()))
          .toList();
    } else {
      model_mst = tempData;
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
                  'Model List (${model_mst.length})',
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
              itemCount: model_mst.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.white70,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => model_information(
                                  model_mst[index]['model_id']))).then((value) {
                        if (value != null) {
                          loadData();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(model_mst[index]['brand'],
                                style: GoogleFonts.roboto(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Expanded(
                            child: Text(model_mst[index]['modelname'],
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                          ),
                          Expanded(
                            child: Text(model_mst[index]['discount'],
                                textAlign: TextAlign.right,
                                style: GoogleFonts.roboto(
                                    color: Colors.blue.shade800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
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
                          builder: (context) => model_information('')))
                  .then((value) {
                if (value != null) {
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
