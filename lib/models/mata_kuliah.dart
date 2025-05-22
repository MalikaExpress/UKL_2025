class MataKuliah {
  final int id;
  final String? nama;
  final int? sks;

  MataKuliah({required this.id, this.nama, this.sks});

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama_matkul'],
      sks: int.tryParse(json['sks'].toString()) ?? 0,
    );
  }
}
