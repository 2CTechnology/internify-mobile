// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:simag_app/app/modules/profile/views/member_team_view.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/views/progress_track.dart';

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
            final alurData =
                controller.fetchAlurMagangController.alurMagangModel.value.data;
            if (alurData == null || alurData.dataAlurMagang == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.info_outline,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Alur magang belum tersedia,\nsilahkan isi data kelompok di profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                try {
                  if (!Get.isRegistered<FetchKelompokController>()) {
                    Get.put(FetchKelompokController());
                  }
                  if (!Get.isRegistered<FetchAlurMagangController>()) {
                    Get.put(FetchAlurMagangController());
                  }

                  await controller.fetchTimelineData();
                } catch (e, stack) {
                  print("❌ Exception during refresh: $e");
                  print(stack);
                  Get.snackbar(
                    "Error",
                    "Failed to refresh timeline",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
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
                            ?.statusSuratBalasan),
                    ProgressTrack(
                      data: controller.fetchAlurMagangController.alurMagangModel
                          .value.data.dataAlurMagang?.suratPelaksanaan,
                      title: "Letter of Assignment",
                      descriptionNull:
                          "Please complete the previous step first",
                      descriptionNotNull:
                          "Please wait for the letter of assignment to be issued",
                      pageName: "surat-pelaksanaan",
                      dataStatus: controller
                          .fetchAlurMagangController
                          .alurMagangModel
                          .value
                          .data
                          .dataAlurMagang
                          ?.statusSuratBalasan,
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
