// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/timeline_controller.dart';

class ProgressTrack extends StatelessWidget {
  final String title;
  final String descriptionNull;
  final String descriptionNotNull;
  final dynamic data;
  final String pageName;
  final dynamic dataStatus;
  static bool isSnackbarActive = false;

  const ProgressTrack({
    Key? key,
    required this.title,
    required this.data,
    required this.descriptionNull,
    required this.descriptionNotNull,
    required this.pageName,
    this.dataStatus,
  }) : super(key: key);

  void showSingleSnackbar(String title, String message, Color backgroundColor) {
    if (!isSnackbarActive) {
      isSnackbarActive = true;
      Get.snackbar(
        title,
        message,
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 1650),
        backgroundColor: backgroundColor,
        colorText: Colors.white,
        borderWidth: 5.0,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20.0),
        icon: const Icon(CupertinoIcons.info_circle),
      );
      Future.delayed(const Duration(milliseconds: 1800), () {
        isSnackbarActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FetchAlurMagangController fetchAlurMagangController = Get.find();
    TimelineController controller = Get.find<TimelineController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(38, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onPressed: () {
          final hasTeam = controller.anggotaList.isNotEmpty;
          final alur = controller.fetchAlurMagangController.alurMagangModel
              .value.data.dataAlurMagang;
          final proposal = alur?.proposal;
          final replyLetter = alur?.suratBalasan;
          final statusProposal = alur?.statusProposal;
          final statusSuratBalasan = alur?.statusSuratBalasan;

          if (pageName == "my-team") {
            if (hasTeam) {
              showSingleSnackbar("Info", "Go to profile page to see your team",
                  Color.fromARGB(255, 70, 116, 222));
            } else {
              showSingleSnackbar("Error",
                  "Please fill in your team details in profile", Colors.red);
            }
            return;
          }

          // surat pengantar dibuat di third party tidak dibuat atau diterima di aplikasi ini
          // flow: buat team -> upload proposal -> upload reply letter -> download surat pelaksanaan
          // upload proposal accessible only if team is created
          // upload surat balasan accessible only if proposal is accepted
          // download surat pelaksanaan accessible only if surat balasan is uploaded

          if (!hasTeam &&
              (pageName == "apply-jobs" || pageName == "surat-balasan")) {
            showSingleSnackbar(
                "Error", "Please complete your team details first", Colors.red);
            return;
          }

          if ((proposal == null || proposal == '') &&
              (pageName == "surat-balasan")) {
            showSingleSnackbar(
                "Error", "Please upload your proposal first", Colors.red);
            return;
          }

          if (pageName == "surat-balasan" && statusProposal != "diterima") {
            showSingleSnackbar(
              "Not available",
              "You can upload reply letter only after your proposal is accepted.",
              Colors.red,
            );
            return;
          }

          if ((pageName == "surat-pelaksanaan") && statusSuratBalasan != "diterima") {
            showSingleSnackbar(
                "Error", "Reply letter must be accepted first before proceeds", Colors.red);
            return;
          }

          Get.toNamed(pageName);
        },
        //  pengecekan kolom progresstrack hanya ada untuk proposal saja... team, reply letter, dan surat pelaksanaan tidak ada pengecekan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle state untuk proposal
            if (pageName == "apply-jobs") ...[
              if (data == null || data == 0 || data == "belum ada")
                buildProgressState(
                  title: title,
                  iconColor: Colors.grey,
                  description: descriptionNull,
                )
              else if (data == "menunggu konfirmasi")
                buildProgressState(
                  title: title,
                  iconColor: const Color.fromARGB(255, 173, 216, 230),
                  description: "Waiting for confirmation",
                )
              else if (data == "revisi")
                buildProgressState(
                  title: title,
                  iconColor: const Color.fromARGB(255, 255, 223, 77),
                  description:
                      "There is a revision because ${fetchAlurMagangController.alurMagangModel.value.data.dataAlurMagang?.revisiProposal}, Please upload the revised proposal",
                )
              else if (data == "ditolak")
                buildProgressState(
                  title: title,
                  iconColor: Colors.red,
                  description:
                      "Your proposal has been rejected because ${fetchAlurMagangController.alurMagangModel.value.data.dataAlurMagang?.alasanProposalDitolak}. Please choose another internship place",
                )
              else if (data == "diterima")
                buildProgressState(
                  title: title,
                  iconColor: const Color.fromARGB(255, 70, 116, 222),
                  description:
                      "Congratulations, your proposal has been accepted, please proceed to the next step",
                )
              else
                buildProgressState(
                  title: title,
                  iconColor: Colors.grey,
                  description: descriptionNull,
                ),
            ]
            // Placeholder untuk Reply Letter dan LoA
            else if (pageName == "my-team") ...[
              buildProgressState(
                title: title,
                iconColor: controller.anggotaList.isNotEmpty
                    ? const Color.fromARGB(255, 70, 116, 222)
                    : Colors.grey,
                description: controller.anggotaList.isNotEmpty
                    ? descriptionNotNull
                    : descriptionNull,
              ),
            ],

            if (pageName == "surat-balasan") ...[
              if (data == null || data == 0 || data == "belum ada")
                buildProgressState(
                  title: title,
                  iconColor: Colors.grey,
                  description: descriptionNull,
                )
              else if (dataStatus == "menunggu konfirmasi")
                buildProgressState(
                  title: title,
                  iconColor: const Color.fromARGB(255, 173, 216, 230),
                  description: "Waiting for confirmation",
                )
              else if (dataStatus == "mengulang")
                buildProgressState(
                  title: title,
                  iconColor: Colors.red,
                  description:
                      "Your reply letter was reviewed but rejected by the company. Please search for another internship placement.",
                )
              else if (dataStatus == "diterima")
                buildProgressState(
                  title: title,
                  iconColor: const Color.fromARGB(255, 70, 116, 222),
                  description:
                      "Congratulations, your reply letter has been accepted. Please wait for the Assignment Letter to be issued.",
                )
              else
                buildProgressState(
                  title: title,
                  iconColor: Colors.grey,
                  description: descriptionNull,
                ),

            ] else if (pageName == "surat-pelaksanaan") ...[
              buildProgressState(
                title: title,
                iconColor: (data != null && data != "")
                    ? const Color.fromARGB(255, 70, 116, 222)
                    : Colors.grey,
                description: descriptionNull,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildProgressState({
    required String title,
    required Color iconColor,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.check_circle_rounded, color: iconColor, size: 34),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(height: 2),
        const SizedBox(height: 10),
        Text(description),
      ],
    );
  }
}
