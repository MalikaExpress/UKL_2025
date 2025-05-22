import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status = false;
  String? message;
  int? id;
  String? nama_user;
  String? username;
  String? role;

  UserLogin({
    this.status,
    this.message,
    this.id,
    this.nama_user,
    this.username,
    this.role,
  });


  Future<void> prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("status", status ?? false);
    prefs.setString("message", message ?? "");
    prefs.setInt("id", id ?? 0);
    prefs.setString("nama_user", nama_user ?? "");
    prefs.setString("username", username ?? "");
    prefs.setString("role", role ?? "");
  }


  static Future<UserLogin> getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserLogin(
      status: prefs.getBool("status") ?? false,
      message: prefs.getString("message") ?? "",
      id: prefs.getInt("id") ?? 0,
      nama_user: prefs.getString("nama_user") ?? "",
      username: prefs.getString("username") ?? "",
      role: prefs.getString("role") ?? "",
    );
  }
}
