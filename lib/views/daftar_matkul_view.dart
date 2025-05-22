import 'package:flutter/material.dart';
import 'package:movie_app/models/mata_kuliah.dart';
import 'package:movie_app/services/matkul_service.dart';

class DaftarMatkulPage extends StatefulWidget {
  const DaftarMatkulPage({super.key});

  @override
  State<DaftarMatkulPage> createState() => _DaftarMatkulPageState();
}

class _DaftarMatkulPageState extends State<DaftarMatkulPage> {
  final MatkulService _service = MatkulService();
  late Future<List<MataKuliah>> _futureMatkul;
  final Map<int, bool> selectedMap = {};
  List<MataKuliah> matkulList = [];

  @override
  void initState() {
    super.initState();
    _futureMatkul = _service.fetchMatkul();
  }

  void _submitSelected() async {
    List<MataKuliah> selectedMatkul = selectedMap.entries
        .where((entry) => entry.value)
        .map((entry) =>
            matkulList.firstWhere((matkul) => matkul.id == entry.key))
        .toList();

    final response = await _service.submitSelectedMatkul(selectedMatkul);

  
    print("STATUS: ${response.status}");
    print("MESSAGE: ${response.message}");

    if (selectedMatkul.isEmpty) {
      print("Tidak ada mata kuliah yang dipilih.");
    } else {
      print("Mata kuliah terpilih:");
      for (var mk in selectedMatkul) {
        print("- ${mk.id}: ${mk.nama} (${mk.sks} SKS)");
      }
    }

    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(response.status ? "Berhasil" : "Gagal"),
        content: Text(response.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Pilih Mata Kuliah"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: FutureBuilder<List<MataKuliah>>(
        future: _futureMatkul,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          } else if (snapshot.hasError) {
            print("Terjadi error saat fetch: ${snapshot.error}");
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("Data mata kuliah kosong.");
            return const Center(child: Text("Tidak ada data mata kuliah."));
          } else {
            matkulList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: matkulList.length,
                      itemBuilder: (context, index) {
                        final matkul = matkulList[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              matkul.nama ?? "Tidak ada nama",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("SKS: ${matkul.sks ?? '-'}"),
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Text(
                                matkul.id.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            trailing: Checkbox(
                              value: selectedMap[matkul.id] ?? false,
                              activeColor: Colors.purple,
                              onChanged: (val) {
                                setState(() {
                                  selectedMap[matkul.id] = val!;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitSelected,
                      icon: const Icon(Icons.send),
                      label: const Text("Kirim Mata Kuliah Terpilih"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
