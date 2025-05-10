// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:simag_app/app/modules/profile/views/member_team_view.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';

import '../controllers/timeline_controller.dart';

class TimelineView extends GetView<TimelineController> {
  const TimelineView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // FetchAlurMagangController fetchAlurMagangController =
    //     Get.put(FetchAlurMagangController());
    // fetchAlurMagangController.fetchAlurMagang();
    // print(timelineController.alurMagangModel.value.data.dataAlurMagang.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Timeline",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 72, 71, 156),
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.fetchAlurMagangController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller
                  .fetchAlurMagangController.alurMagangModel.value.data ==
              null)
            return const Text("Data not found");
          else {
            return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchTimelineData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProgressTrack(
                      // data: fetchAlurMagangController
                      //     .alurMagangModel.value.data.dataAlurMagang?.idKelompok,
                      data: controller.anggotaList.isNotEmpty ? 1 : 0,
                      title: "Team",
                      descriptionNull:
                          "Please fill in your team by tapping on this box",
                      descriptionNotNull: "Team is already filled in",
                      pageName: "my-team",
                    ),
                    ProgressTrack(
                      title: "Internship Proposal",
                      data: controller.fetchAlurMagangController.alurMagangModel
                          .value.data.dataAlurMagang?.statusProposal,
                      descriptionNull: "Please complete the proposal",
                      descriptionNotNull: "",
                      pageName: "apply-jobs",
                    ),
                    ProgressTrack(
                        data: controller
                            .fetchAlurMagangController
                            .alurMagangModel
                            .value
                            .data
                            .dataAlurMagang
                            ?.suratBalasan,
                        title: "Reply Letter",
                        descriptionNull:
                            "Please upload the reply letter if you have it",
                        descriptionNotNull:
                            "Reply letter has been uploaded, waiting for the letter of acceptance",
                        pageName: "surat-balasan",
                        dataStatus: controller
                            .fetchAlurMagangController
                            .alurMagangModel
                            .value
                            .data
                            .dataAlurMagang
                            ?.statusProposal),
                    ProgressTrack(
                      data: controller.fetchAlurMagangController.alurMagangModel
                          .value.data.dataAlurMagang?.suratPengantar,
                      title: "Letter of Assignment",
                      descriptionNull:
                          "Letter of acceptance is being processed",
                      descriptionNotNull:
                          "Please download the internship acceptance letter",
                      pageName: "download-surat-pelaksanaan",
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

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
          if (pageName == "my-team") {
            if (controller.anggotaList.isNotEmpty) {
              // kalau sudah ada anggota
              // Get.to(() => MemberTeamView(
              //       memberCount: controller.anggotaList.length,
              //       initialMembersData: controller.anggotaList
              //           .map((e) => MemberData(
              //                 fullname: e.nama,
              //                 nim: e.nim,
              //                 prodiId: e.idProdi,
              //                 angkatan: e.angkatan,
              //                 golongan: e.golongan,
              //                 dateOfBirth:
              //                     e.createdAt, // atau dari date lahir kalau ada
              //                 gender: 'Male', // Default dulu atau mapping lagi
              //                 phoneNumber: '',
              //                 email: '',
              //               ))
              //           .toList(),
              //     ));
              showSingleSnackbar("Info", "Go to profile page to see your team", Color.fromARGB(255, 70, 116, 222));
            } else {
              showSingleSnackbar("Error", "Please fill in your team details in profile", Colors.red);
            }
          } else if (pageName == "download-surat-pengantar") {
            controller.downloadFile();
          } else {
            final hasTeam = controller.anggotaList.isNotEmpty;
            final proposal = controller.fetchAlurMagangController
                .alurMagangModel.value.data.dataAlurMagang?.proposal;
            final replyLetter = controller.fetchAlurMagangController
                .alurMagangModel.value.data.dataAlurMagang?.suratBalasan;

            if (!hasTeam &&
                (pageName == "apply-jobs" ||
                    pageName == "surat-balasan" ||
                    pageName == "download-surat-pengantar")) {
              showSingleSnackbar("Error", "Please complete previous steps", Colors.red);
              return;
            }

            if ((proposal == null || proposal == '') &&
                (pageName == "surat-balasan" ||
                    pageName == "download-surat-pengantar")) {
              showSingleSnackbar("Error", "Please complete previous steps", Colors.red);
              return;
            }

            if ((replyLetter == null || replyLetter == '') &&
                pageName == "download-surat-pelaksanaan") {
              showSingleSnackbar("Error", "Please complete previous steps", Colors.red);
              return;
            }
            Get.toNamed(pageName);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data == null || data == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.grey, size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(descriptionNull),
                ],
              )
            else if (data == "belum ada")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.grey, size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Please upload internship proposal"),
                ],
              )
            else if (data == "menunggu konfirmasi")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Color.fromARGB(255, 173, 216, 230), size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Waiting for confirmation"),
                ],
              )
            else if (data == "revisi")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Color.fromARGB(255, 255, 223, 77), size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "There is a revision because ${fetchAlurMagangController.alurMagangModel.value.data.dataAlurMagang?.revisiProposal}, Please upload the revised proposal"),
                ],
              )
            else if (data == "ditolak")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.red, size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Your proposal has been rejected because ${fetchAlurMagangController.alurMagangModel.value.data.dataAlurMagang?.alasanProposalDitolak}. Please choose another internship place"),
                ],
              )
            else if (data == "diterima")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Color.fromARGB(255, 70, 116, 222), size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      "Congratulations, your proposal has been accepted, please proceed to the next step"),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: Color.fromARGB(255, 70, 116, 222), size: 34),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(descriptionNotNull)
                ],
              )
          ],
        ),
      ),
    );
  }
}
