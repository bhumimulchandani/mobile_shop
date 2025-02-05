import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart' as a;
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';

class colour_information extends StatefulWidget {
  String main_id = "";

  colour_information(this.main_id);

  @override
  State<colour_information> createState() => _colour_informationState();
}

class _colour_informationState extends State<colour_information> {
  var ob_mysql = mysql_class();

  TextEditingController colournameCnt = TextEditingController();
  TextEditingController add_modify_Cnt = TextEditingController(text: "ADD");

  TextStyle formHeaderStyle = GoogleFonts.manrope(
    fontSize: 16,
    color: a.Colors.blue.shade900,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();

    load_data();
  }

  void load_data() async {
    setState(() {});
    if (widget.main_id != "") {
      get_data_method_by_id();
    }
  }

  void save_and_update_button_method() async {
    if (await save_data_alert_method(context) == 1) {
      return;
    }

    String col_name = colournameCnt.text.replaceAll("'", "''");

    String query = "insert into colour_mst(colourname) values('$col_name')";

    if (widget.main_id != "") {
      query =
          " update colour_mst set colourname='$col_name' where colour_id='${widget.main_id}'";
    }

    var status = await ob_mysql.public_insert_update_delete_data_method(query);
    if (status != 'success') {
      await mysql_class.show_confirmation_dialog_box(
          context, "Error occurred!", status, "Ok");
      return;
    }

    if (widget.main_id != "") {
      List<String> modelData = [widget.main_id, col_name];
      Navigator.pop(context, modelData);
    } else {
      List<String> modelData = [mysql_class.lastInsertID, col_name];
      Navigator.pop(context, modelData);
    }
  }

  void delete_button_method(BuildContext context) async {
    if (widget.main_id != "") {
      bool confirmDelete = await mysql_class.show_confirmation_dialog_box(
          context,
          "Confirmation",
          "Do you want to delete this record?",
          "yes_no");

      // If the user confirms deletion
      if (confirmDelete) {
        var data_dt = await ob_mysql.public_select_data_method(
            "select colour_id as existance_id from in_info_mst where colour_id=${widget.main_id}");
        if (data_dt.length > 0) {
          await mysql_class.show_confirmation_dialog_box(
              context, "Stop", "This is Used in Some Entries", "Ok");
          return;
        }

        String query =
            " delete from colour_mst where colour_id='${widget.main_id}'";

        var status =
            await ob_mysql.public_insert_update_delete_data_method(query);
        if (status != 'success') {
          await mysql_class.show_confirmation_dialog_box(
              context, "Error occurred!", status, "Ok");
          return;
        }

        Navigator.pop(context, true);
      }
    }
  }

  Future<int> save_data_alert_method(BuildContext context) async {
    if (colournameCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Colour Name", "Ok");
      return 1;
    }
    return ob_mysql.existance_check("colour_mst", "colourname",
        colournameCnt.text, "colour_id", widget.main_id, context);
    return 0;
  }

  void reset_data() {
    this.setState(() {
      colournameCnt.clear();

      widget.main_id = "";
      add_modify_Cnt.text = "Add";
    });
  }

  void get_data_method_by_id() async {
    String query =
        "SELECT * FROM colour_mst WHERE colour_id='${widget.main_id}' ORDER BY colourname ASC";

    var data_dt = await ob_mysql.public_select_data_method(query);

    colournameCnt.text = data_dt[0]["colourname"].toString();

    add_modify_Cnt.text = "Modify";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgd_1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          title: Text(
            'Colour Info : ${add_modify_Cnt.text}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              fu.InfoLabel(
                label: "Colour Name",
                labelStyle:
                    formHeaderStyle.copyWith(color: Colors.blue.shade800),
                child: a.TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: mysql_class.searchableDecoration,
                  autofocus: true,
                  controller: colournameCnt,
                  style: formHeaderStyle,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        save_and_update_button_method();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text(
                        widget.main_id == '' ? 'Save' : 'Update',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  if (widget.main_id != '') ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          delete_button_method(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.red.shade600,
                        ),
                        child: Text('Delete',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16)),
                      ),
                    )
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
