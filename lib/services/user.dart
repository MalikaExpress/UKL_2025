import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:movie_app/models/response_data_map.dart';
import 'package:movie_app/models/user_login.dart';
import 'package:movie_app/services/url.dart' as url;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  Future<ResponseDataMap> loginUser(Map<String, dynamic> data) async {
    try {
      var uri = Uri.parse('${url.BaseUrl}/login');

      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var dataResponse = json.decode(response.body);

        if (dataResponse["status"] == true) {
          UserLogin userLogin = UserLogin(
            status: dataResponse["status"],
            message: dataResponse["message"],
            id: dataResponse["data"]["id"],
            nama_user: dataResponse["data"]["name"],
            username: dataResponse["data"]["username"],
            role: dataResponse["data"]["role"],
          );
          await userLogin.prefs();

          return ResponseDataMap(
            status: true,
            message: "Sukses login user",
            data: dataResponse,
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: dataResponse["message"] ?? 'Username dan password salah',
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Gagal login user dengan kode error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: "Terjadi kesalahan saat login: $e",
      );
    }
  }

  Future<ResponseDataMap> registerUser(Map<String, dynamic> data,
      {XFile? file}) async {
    try {
      var uri = Uri.parse('${url.BaseUrl}/register');
      var request = http.MultipartRequest('POST', uri);

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (file != null) {
        final mimeType =
            lookupMimeType(file.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');

        print('Uploading file: ${file.path}, mimeType: $mimeType');

        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              bytes,
              filename: file.name,
              contentType: MediaType(mimeSplit[0], mimeSplit[1]),
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto',
              file.path,
              contentType: MediaType(mimeSplit[0], mimeSplit[1]),
            ),
          );
        }
      } else {
        print('No file selected');
      }

      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();

      print('Response status: ${streamedResponse.statusCode}');
      print('Response body: $responseString');

      if (streamedResponse.statusCode == 200) {
        var responseData = json.decode(responseString);

        if (responseData["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Sukses menambah user",
            data: responseData,
          );
        } else {
          String message = '';
          if (responseData["message"] is Map) {
            for (String key in responseData["message"].keys) {
              message += '${responseData["message"][key][0]}\n';
            }
            message = message.trim();
          } else {
            message = responseData["message"] ?? "Gagal menambah user";
          }

          return ResponseDataMap(
            status: false,
            message: message,
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message:
              "Gagal menambah user dengan kode error ${streamedResponse.statusCode}",
        );
      }
    } catch (e) {
      print('Error saat register user: $e');
      return ResponseDataMap(
        status: false,
        message: "Terjadi kesalahan saat register user: $e",
      );
    }
  }
}
