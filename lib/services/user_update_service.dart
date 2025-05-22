import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiResponse {
  final bool status;
  final String message;
  final dynamic data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class UserUpdateService {
  final String baseUrl = "https://learn.smktelkom-mlg.sch.id/ukl1/api";

  Future<ApiResponse> updateUser(Map<String, dynamic> data) async {
    try {
      final String id = data['id'].toString();
      final url = Uri.parse("$baseUrl/update/$id");

      Map<String, String> body = {
        "nama_pelanggan": data["nama_pelanggan"],
        "gender": data["gender"],
        "alamat": data["alamat"],
        "telepon": data["telepon"],
      };

      final response = await http
          .put(
            url,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ApiResponse.fromJson(responseData);
      } else {
        return ApiResponse(
          status: false,
          message: "Gagal update. Kode: ${response.statusCode}",
        );
      }
    } on SocketException {
      return ApiResponse(
        status: false,
        message: "Tidak ada koneksi internet.",
      );
    } on TimeoutException {
      return ApiResponse(
        status: false,
        message: "Permintaan ke server timeout.",
      );
    } catch (e) {
      return ApiResponse(
        status: false,
        message: "Terjadi kesalahan: $e",
      );
    }
  }

  Future<ApiResponse> fetchUserProfile() async {
    try {
      final url = Uri.parse("$baseUrl/profil");
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ApiResponse.fromJson(responseData);
      } else {
        return ApiResponse(
          status: false,
          message: "Gagal mengambil profil. Kode: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse(
        status: false,
        message: "Kesalahan saat mengambil profil: $e",
      );
    }
  }
}
