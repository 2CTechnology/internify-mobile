// To parse this JSON data, do
//
//     final kelompokModel = kelompokModelFromJson(jsonString);

import 'dart:convert';

KelompokModel kelompokModelFromJson(String str) =>
    KelompokModel.fromJson(json.decode(str));

String kelompokModelToJson(KelompokModel data) => json.encode(data.toJson());

class KelompokModel {
  String message;
  DataKelompok response;

  KelompokModel({
    required this.message,
    required this.response,
  });

  factory KelompokModel.fromJson(Map<String, dynamic> json) => KelompokModel(
        message: json["message"],
        response: DataKelompok.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "response": response.toJson(),
      };
}

class DataKelompok {
  int id;
  String namaKelompok;
  int idUsers;
  int? idDospem;
  DateTime createdAt;
  DateTime updatedAt;
  String? namaDosen;
  List<Anggota> anggota;

  DataKelompok({
    required this.id,
    required this.namaKelompok,
    required this.idUsers,
    required this.idDospem,
    required this.createdAt,
    required this.updatedAt,
    required this.namaDosen,
    required this.anggota,
  });

  factory DataKelompok.fromJson(Map<String, dynamic> json) => DataKelompok(
        id: json["id"],
        namaKelompok: json["nama_kelompok"],
        idUsers: json["id_users"],
        idDospem: json["id_dospem"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        namaDosen: json["nama_dosen"],
        anggota:
            List<Anggota>.from(json["anggota"].map((x) => Anggota.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_kelompok": namaKelompok,
        "id_users": idUsers,
        "id_dospem": idDospem,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "nama_dosen": namaDosen,
        "anggota": List<dynamic>.from(anggota.map((x) => x.toJson())),
      };
}

class Anggota {
  int id;
  String nim;
  int idKelompok;
  String nama;
  int idProdi;
  String angkatan;
  String golongan;
  DateTime createdAt;
  DateTime updatedAt;

  Anggota({
    required this.id,
    required this.nim,
    required this.idKelompok,
    required this.nama,
    required this.idProdi,
    required this.angkatan,
    required this.golongan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) => Anggota(
        id: json["id"],
        nim: json["nim"],
        idKelompok: json["id_kelompok"],
        nama: json["nama"],
        idProdi: json["id_prodi"],
        angkatan: json["angkatan"],
        golongan: json["golongan"],
        createdAt: DateTime.tryParse(json["created_at"] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nim": nim,
        "id_kelompok": idKelompok,
        "nama": nama,
        "id_prodi": idProdi,
        "angkatan": angkatan,
        "golongan": golongan,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
