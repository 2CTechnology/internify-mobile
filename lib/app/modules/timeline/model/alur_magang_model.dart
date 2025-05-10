// To parse this JSON data, do
//
//     final alurMagangModel = alurMagangModelFromJson(jsonString);

import 'dart:convert';

AlurMagangModel alurMagangModelFromJson(String str) =>
    AlurMagangModel.fromJson(json.decode(str));

String alurMagangModelToJson(AlurMagangModel data) =>
    json.encode(data.toJson());

class AlurMagangModel {
  String message;
  Data data;

  AlurMagangModel({
    required this.message,
    required this.data,
  });

  factory AlurMagangModel.fromJson(Map<String, dynamic> json) =>
      AlurMagangModel(
        message: json["message"] ?? '',
        data: json ["data"] != null
          ? Data.fromJson(json["data"])
          : Data(message: '', dataAlurMagang: null),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String message;
  DataAlurMagang? dataAlurMagang;

  Data({
    required this.message,
    required this.dataAlurMagang,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        dataAlurMagang: json["dataAlurMagang"] == null
            ? null
            : DataAlurMagang.fromJson(json["dataAlurMagang"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "dataAlurMagang": dataAlurMagang?.toJson(),
      };
}

class DataAlurMagang {
  int id;
  int idKelompok;
  String? proposal;
  String statusProposal;
  dynamic revisiProposal;
  dynamic alasanProposalDitolak;
  String? tempatMagang;
  String? namaPosisi;
  dynamic suratBalasan;
  dynamic suratPengantar;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic idTempatMagang;

  DataAlurMagang({
    required this.id,
    required this.idKelompok,
    required this.proposal,
    required this.statusProposal,
    required this.revisiProposal,
    required this.alasanProposalDitolak,
    required this.tempatMagang,
    required this.namaPosisi,
    required this.suratBalasan,
    required this.suratPengantar,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.idTempatMagang,
  });

  factory DataAlurMagang.fromJson(Map<String, dynamic> json) => DataAlurMagang(
        id: json["id"],
        idKelompok: json["id_kelompok"],
        proposal: json["proposal"],
        statusProposal: json["status_proposal"],
        revisiProposal: json["revisi_proposal"],
        alasanProposalDitolak: json["alasan_proposal_ditolak"],
        tempatMagang: json["tempat_magang"],
        namaPosisi: json["nama_posisi"],
        suratBalasan: json["surat_balasan"],
        suratPengantar: json["surat_pengantar"],
        status: json["status"],
        createdAt: DateTime.tryParse(json["created_at"] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"] ?? '') ?? DateTime.now(),
        idTempatMagang: json["id_tempat_magang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_kelompok": idKelompok,
        "proposal": proposal,
        "status_proposal": statusProposal,
        "revisi_proposal": revisiProposal,
        "alasan_proposal_ditolak": alasanProposalDitolak,
        "tempat_magang": tempatMagang,
        "nama_posisi": namaPosisi,
        "surat_balasan": suratBalasan,
        "surat_pengantar": suratPengantar,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "id_tempat_magang": idTempatMagang,
      };
}
