import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart' as a;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';

class model_information extends StatefulWidget {
  String main_id = "";

  model_information(this.main_id);

  @override
  State<model_information> createState() => _model_informationState();
}

class _model_informationState extends State<model_information> {
  var ob_mysql = mysql_class();

  String? selectedValue;

  TextEditingController modelnameCnt = TextEditingController();
  TextEditingController discountCnt = TextEditingController();

  TextEditingController add_modify_Cnt = TextEditingController(text: "ADD");

  TextStyle formHeaderStyle = GoogleFonts.manrope(
    fontSize: 16,
    color: a.Colors.blue.shade900,
    fontWeight: FontWeight.w600,
  );

  List<String> items = [
    'Asus',
    'Blackzone',
    'Google',
    'Infinix',
    'Iphone',
    'LG',
    'Moto',
    'OnePlus',
    'Oppo',
    'Poco',
    'Realme',
    'Redmi',
    'Samsung',
    'Tab',
    'Tecno',
    'Vivo',
    'Ziox',
    'Xiaomi',
    'Nokia',
  ];

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

    String model_name = modelnameCnt.text.replaceAll("'", "''");
    String selectedvalue = selectedValue.toString();
    String discount = discountCnt.text.replaceAll("'", "''");

    String query =
        "insert into model_mst(modelname, brand, discount) values('$model_name','$selectedvalue','$discount')";

    if (widget.main_id != "") {
      query =
          " update model_mst set modelname='$model_name', brand='$selectedvalue', discount='$discount' where model_id='${widget.main_id}'";
    }

    var status = await ob_mysql.public_insert_update_delete_data_method(query);
    if (status != 'success') {
      await mysql_class.show_confirmation_dialog_box(
          context, "Error occurred!", status, "Ok");
      return;
    }

    if (widget.main_id != "") {
      List<String> modelData = [widget.main_id, selectedvalue, model_name];
      Navigator.pop(context, modelData);
    } else {
      List<String> modelData = [
        mysql_class.lastInsertID,
        selectedvalue,
        model_name
      ];
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
            "select model_id as existance_id from in_info_mst where model_id=${widget.main_id}");
        if (data_dt.length > 0) {
          await mysql_class.show_confirmation_dialog_box(
              context, "Stop", "This is Used in Some Entries", "Ok");
          return;
        }

        String query =
            " delete from model_mst where model_id='${widget.main_id}'";

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
    if (modelnameCnt.text.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Required", "Please Enter Model Name", "Ok");
      return 1;
    }
    if (selectedValue == null || selectedValue!.isEmpty) {
      await mysql_class.show_confirmation_dialog_box(
          context, "Alert", "Please Select Brand Type", "Ok");
      return 1;
    }
    return ob_mysql.existance_check("model_mst", "modelname", modelnameCnt.text,
        "model_id", widget.main_id, context);

    return 0;
  }

  void reset_data() {
    this.setState(() {
      modelnameCnt.clear();
      selectedValue = null;
      discountCnt.clear();

      widget.main_id = "";
      add_modify_Cnt.text = "Add";
    });
  }

  void get_data_method_by_id() async {
    String query =
        "SELECT * FROM model_mst WHERE model_id='${widget.main_id}' Order by brand, modelname";

    var data_dt = await ob_mysql.public_select_data_method(query);
    modelnameCnt.text = data_dt[0]["modelname"].toString();
    selectedValue = data_dt[0]["brand"].toString();
    discountCnt.text = data_dt[0]["discount"].toString();

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
            'Model Info : ${add_modify_Cnt.text}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              children: [
                fu.InfoLabel(
                  label: "Model Name",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: modelnameCnt,
                    style: formHeaderStyle,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: fu.InfoLabel(
                        label: 'Brand',
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: DropdownButtonFormField<String>(
                          value: selectedValue,
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white70,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          dropdownColor: Colors.grey.shade200,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String? newValue) {
                            FocusScope.of(context).nextFocus();
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: fu.InfoLabel(
                        label: "Discount",
                        labelStyle: formHeaderStyle.copyWith(
                            color: Colors.blue.shade800),
                        child: a.TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              isDense: true,
                              border: a.OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              filled: true,
                              fillColor: Colors.white70),
                          style: formHeaderStyle,
                          controller: discountCnt,
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
