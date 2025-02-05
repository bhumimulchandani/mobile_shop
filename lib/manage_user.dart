import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fu;
import 'package:flutter/material.dart' as a;
import 'package:google_fonts/google_fonts.dart';
import 'package:shree_vimal_mobile_dhule/dbservices.dart';
import 'package:shree_vimal_mobile_dhule/modal/app_user.dart';

class ManageUserScreen extends StatefulWidget {
  final bool? add;
  final AppUser? user;
  const ManageUserScreen({super.key, this.add, this.user});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameCnt = TextEditingController(),
      unameCnt = TextEditingController(),
      pswdCnt = TextEditingController();
  bool admin = false;

  TextStyle formHeaderStyle = GoogleFonts.manrope(
    fontSize: 16,
    color: a.Colors.blue.shade900,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    if (!widget.add!) {
      nameCnt.text = widget.user!.name.toString();
      unameCnt.text = widget.user!.uname.toString();
      pswdCnt.text = widget.user!.pswd.toString();
      admin = widget.user!.admin!;
    }
  }

  void manageUser() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String query = widget.add!
          ? "insert into user_mst(name, username, userpassword, user_type) values('${nameCnt.text}', '${unameCnt.text}', '${pswdCnt.text}', '${admin ? 'A' : 'U'}')"
          : "update user_mst set name='${nameCnt.text}',username='${unameCnt.text}', userpassword='${pswdCnt.text}', user_type='${admin ? 'A' : 'U'}' where user_id=${widget.user!.id}";

      var status =
          await mysql_class().public_insert_update_delete_data_method(query);
      if (status != 'success') {
        await mysql_class.show_confirmation_dialog_box(
            context, "Error occurred!", status, "Ok");
        return;
      }
      Navigator.pop(context, true);
    }
  }

  void delete_button_method(BuildContext context) async {
    bool confirmDelete = await mysql_class.show_confirmation_dialog_box(context,
        "Confirmation", "Do you want to delete this record?", "yes_no");

    // If the user confirms deletion
    if (confirmDelete) {
      String query =
          " delete from user_mst where user_id='${widget.user!.id}'ORDER BY name ASC";
      var status =
          await mysql_class().public_insert_update_delete_data_method(query);
      if (status != 'success') {
        await mysql_class.show_confirmation_dialog_box(
            context, "Error occurred!", status, "Ok");
        return;
      }
      Navigator.pop(context, true);
    }
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
            'User : ${widget.add! ? 'Add' : 'Edit'}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fu.InfoLabel(
                  label: "Name",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    validator: (val) {
                      if (val == null || val == '') {
                        return '* required';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: nameCnt,
                    style: formHeaderStyle,
                  ),
                ),
                const SizedBox(height: 15),
                fu.InfoLabel(
                  label: "Username",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    validator: (val) {
                      if (val == null || val == '') {
                        return '* required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: unameCnt,
                    style: formHeaderStyle,
                  ),
                ),
                const SizedBox(height: 15),
                fu.InfoLabel(
                  label: "Password",
                  labelStyle:
                      formHeaderStyle.copyWith(color: Colors.blue.shade800),
                  child: a.TextFormField(
                    validator: (val) {
                      if (val == null || val == '') {
                        return '* required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: mysql_class.searchableDecoration,
                    autofocus: true,
                    controller: pswdCnt,
                    style: formHeaderStyle,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: fu.ToggleSwitch(
                      content: Text(
                        'Admin Access',
                        style: formHeaderStyle,
                      ),
                      checked: admin,
                      onChanged: (val) {
                        setState(() {
                          admin = !admin;
                        });
                      }),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          manageUser();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.blue.shade700,
                        ),
                        child: Text(
                          widget.add! ? 'Save' : 'Update',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    if (!widget.add!) ...[
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
