import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/mata_kuliah.dart';

class MatkulService {
  final String fetchUrl =
      'https://learn.smktelkom-mlg.sch.id/ukl1/api/getmatkul';
  final String submitUrl =
      'https://learn.smktelkom-mlg.sch.id/ukl1/api/selectmatkul';

  Future<List<MataKuliah>> fetchMatkul() async {
    try {
      final response = await http.get(Uri.parse(fetchUrl));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['data'] is List) {
          final List<dynamic> matkulList = jsonData['data'];
          return matkulList.map((e) => MataKuliah.fromJson(e)).toList();
        } else {
          throw Exception("Data tidak valid dari server.");
        }
      } else {
        throw Exception(
            "Gagal memuat data mata kuliah. Kode: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat fetch: $e");
    }
  }

  Future<ApiResponse> submitSelectedMatkul(
      List<MataKuliah> selectedList) async {
    final body = {
      "list_matkul": selectedList
          .map((e) => {
                "id": e.id.toString(),
                "nama_matkul": e.nama ?? '',
                "sks": e.sks ?? 0,
              })
          .toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(
          status: false,
          message: "Gagal submit. Kode: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponse(status: false, message: "Error: $e");
    }
  }
}

class ApiResponse {
  final bool status;
  final String message;

  ApiResponse({required this.status, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] == true,
      message: json['message'] ?? 'Terjadi kesalahan.',
    );
  }
}
