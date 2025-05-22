import 'package:flutter/material.dart';
import 'package:movie_app/views/daftar_matkul_view.dart';
import 'package:movie_app/views/login_view.dart';
import 'package:movie_app/views/register_user_view.dart';
import 'package:movie_app/views/update_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => UpdateUserView(),
    },
  ));
}
