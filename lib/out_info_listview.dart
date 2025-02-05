import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/out_info.dart';

class out_listview extends StatefulWidget {
  const out_listview({super.key});

  @override
  State<out_listview> createState() => _out_listviewState();
}

class _out_listviewState extends State<out_listview> {
  TextEditingController searchCnt = TextEditingController();
  List out_info_mst = [];
  List tempData = [];
  bool searchActive = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    String query =
        " Select ii.in_id, ii.voucherno, ii.voucherdate, ii.customername, ii.customernumber, ii.model_id, mi.modelname, mi.brand, ii.imeino1, ii.imeino2, ii.colour_id, ci.colourname, ii.salerate, ii.box, ii.charger, ii.bill, ii.saleexecutive, ii.remarks from out_info_mst as ii inner join model_mst as mi on ii.model_id=mi.model_id inner join colour_mst as ci on ii.colour_id=ci.colour_id Order by voucherdate desc, voucherno desc";
    out_info_mst = await ob_mysql.public_select_data_method(query);
    tempData = out_info_mst;
    searchData(searchCnt.text);
  }

  searchData(String searchVal) {
    if (searchVal != '') {
      out_info_mst = tempData
          .where((element) =>
              element['modelname']
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element['brand']
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()) ||
              element['accountname']
                  .toLowerCase()
                  .contains(searchVal.toLowerCase()))
          .toList();
    } else {
      out_info_mst = tempData;
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
                  'Sale List (${out_info_mst.length})',
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
              itemCount: out_info_mst.length,
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.white70,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => out_information(
                                  out_info_mst[index]['in_id']))).then((value) {
                        if (value ?? false) {
                          loadData();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(out_info_mst[index]['voucherno'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              Text(out_info_mst[index]['voucherdate'],
                                  style: GoogleFonts.roboto(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(out_info_mst[index]['customername'],
                              style: GoogleFonts.roboto(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    '${out_info_mst[index]['brand']} ${out_info_mst[index]['modelname']}',
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              Text(
                                  mysql_class.simpleCurreny(
                                      double.parse(
                                          out_info_mst[index]['salerate']),
                                      showSymbol: false),
                                  style: GoogleFonts.roboto(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Expanded(
                                child: Text(out_info_mst[index]['imeino1'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16)),
                              ),
                              Expanded(
                                child: Text(out_info_mst[index]['imeino2'],
                                    style: GoogleFonts.roboto(
                                        color: Colors.blue.shade800,
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
                      builder: (context) => out_information(''))).then((value) {
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
