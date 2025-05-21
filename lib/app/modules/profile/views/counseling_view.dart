// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:simag_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:simag_app/app/modules/profile/controllers/counseling_controller.dart';
import 'package:simag_app/app/modules/profile/controllers/fetch_counseling.dart';

class CounselingView extends GetView<CounselingController> {
  const CounselingView({super.key});

  @override
  Widget build(BuildContext context) {
    final CounselingController controller = Get.put(CounselingController());
    // final controller = Get.find<CounselingController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
      controller.fetchCounselingSchedule(dbProvider);
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Counseling"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text("Laporan Magang",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text("Upload Laporan Magang dengan format PDF"),
                  SizedBox(
                    height: 17,
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.selectedFile.value == null
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.pickFile(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 32.0),
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.upload_file,
                                color: Colors.grey.shade700),
                            SizedBox(width: 8.0),
                            Text(
                              'Upload Proposal',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf, color: Colors.red),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              controller.selectedFile.value!.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            '${(controller.selectedFile.value!.size / 1024).toStringAsFixed(1)} Kb',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: controller.removeFile,
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  controller.uploadLaporan();
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 70, 116, 222),
                  ),
                ),
                child: Text(
                  "Kirim Laporan",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // ],
            // ),
            // ),
            const SizedBox(height: 32),
            //jadwal mendatang
            const Text("Jadwal Mendatang",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.upcomingSchedules.map<Widget>((schedule) {
                  final jadwalStr = schedule['jadwal'] ?? '';
                  final dateTime = DateTime.tryParse(jadwalStr);

                  final dateFormatted = dateTime != null
                      ? DateFormat('d MMMM yyyy').format(dateTime)
                      : 'Tanggal tidak diketahui';
                  final timeFormatted = dateTime != null
                      ? DateFormat('HH:mm').format(dateTime)
                      : 'Waktu tidak diketahui';

                  return _scheduleCard(
                    subject: schedule['catatan'] ?? 'Tanpa catatan',
                    date: dateFormatted,
                    time: timeFormatted,
                    isDone: false,
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 24),
            //jadwal selesai
            const Text("Selesai",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.pastSchedules.map<Widget>((schedule) {
                  final jadwalStr = schedule['jadwal'] ?? '';
                  final dateTime = DateTime.tryParse(jadwalStr);

                  final dateFormatted = dateTime != null
                      ? DateFormat('d MMMM yyyy').format(dateTime)
                      : 'Tanggal tidak diketahui';
                  final timeFormatted = dateTime != null
                      ? DateFormat('HH:mm').format(dateTime)
                      : 'Waktu tidak diketahui';

                  return _scheduleCard(
                    subject: schedule['catatan'] ?? 'Tanpa catatan',
                    date: dateFormatted,
                    time: timeFormatted,
                    isDone: true,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _scheduleCard({
    required String subject,
    required String date,
    required String time,
    required bool isDone,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text(date),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.check_circle,
                color: isDone ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(time),
            ],
          )
        ],
      ),
    );
  }
}
