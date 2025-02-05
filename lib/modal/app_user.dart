class AppUser {
  String? id, name, uname, pswd;
  bool? admin;

  AppUser({this.id, this.name, this.uname, this.pswd, this.admin});

  factory AppUser.fromJson(Map<String, dynamic> data) {
    return AppUser(id: data['user_id'].toString(), name: data['name'].toString(), uname: data['username'].toString(), pswd: data['userpassword'].toString(), admin: data['user_type']=='A');
  }
}
