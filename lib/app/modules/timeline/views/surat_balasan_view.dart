import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/post_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/timeline_controller.dart';

class SuratBalasan extends GetView<TimelineController> {
  const SuratBalasan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    @override
    final TimelineController controller = Get.put(TimelineController());
    final PostJobsController postController = Get.put(PostJobsController());
    final FetchAlurMagangController fetchAlurMagangController =
        Get.put(FetchAlurMagangController());

    void _submit() {
      if (controller.selectedReplyLetterFile.value != null) {
        postController.filepath =
            controller.selectedReplyLetterFile.value!.path;
        postController.postResponseLetter();
        print("Form valid and submitted");
      } else {
        Get.snackbar(
          "Error",
          "File Is Required",
          animationDuration: const Duration(milliseconds: 300),
          duration: const Duration(milliseconds: 1650),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderWidth: 5.0,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(20.0),
          icon: const Icon(CupertinoIcons.info_circle),
        );
        print("Form not valid");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reply Letter",
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
      body: Obx(() {
        if (fetchAlurMagangController.alurMagangModel.value.data.dataAlurMagang
                ?.statusSuratBalasan ==
            'menunggu konfirmasi') {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.info_circle,
                    color: Colors.grey,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sedang menunggu verifikasi dari admin",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (fetchAlurMagangController.alurMagangModel.value.data
                .dataAlurMagang?.statusSuratBalasan ==
            'diterima') {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 17,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 17,
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Tahap selanjutnya tinggal menunggu Surat Pelaksanaan Magang terbit dari admin",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else if (fetchAlurMagangController.alurMagangModel.value.data
                .dataAlurMagang?.statusSuratBalasan ==
            'mengulang') {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 17,
                ),
                const SizedBox(
                  height: 17,
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Surat balasan telah diterima, silahkan apply ke perusahaan lain. /n Pencet button dibawah untuk melanjutkan",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 17,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 17),
                      const Text(
                        "Upload Reply Letter",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Add your reply letter",
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Obx(
                        () => controller.selectedReplyLetterFile.value == null
                            ? SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      controller.pickReplyLetterFile(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 32.0),
                                    side:
                                        BorderSide(color: Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.upload_file,
                                          color: Colors.grey.shade700),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Upload Letter',
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        controller
                                            .selectedReplyLetterFile.value!.path
                                            .split('/')
                                            .last,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${(controller.selectedReplyLetterFile.value!.lengthSync() / 1024).toStringAsFixed(1)} Kb',
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(width: 8.0),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed:
                                          controller.clearReplyLetterFile,
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
        color: Colors.white,
        height: 78,
        child: Obx(
          () {
            if (fetchAlurMagangController.alurMagangModel.value.data
                    .dataAlurMagang?.statusSuratBalasan ==
                'menunggu konfirmasi') {
              return TextButton(
                onPressed: () {
                  Get.snackbar("Info", "Verification in progress",
                      animationDuration: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 1650),
                      backgroundColor: Colors.grey,
                      colorText: Colors.white,
                      borderWidth: 5.0,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(20.0),
                      icon: const Icon(CupertinoIcons.info_circle));
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(
                    Colors.grey,
                  ),
                ),
                child: const Text(
                  "Verfication in progress",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (fetchAlurMagangController.alurMagangModel.value.data
                    .dataAlurMagang?.statusSuratBalasan ==
                'diterima') {
              return TextButton(
                onPressed: () {
                  Get.snackbar("Info", "Go to next step",
                      animationDuration: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 1650),
                      backgroundColor: Color.fromARGB(255, 70, 116, 222),
                      colorText: Colors.white,
                      borderWidth: 5.0,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(20.0),
                      icon: const Icon(CupertinoIcons.info_circle));
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 70, 116, 222),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (fetchAlurMagangController.alurMagangModel.value.data
                    .dataAlurMagang?.statusSuratBalasan ==
                'mengulang') {
              return TextButton(
                onPressed: () {
                  Get.snackbar("Info",
                      "Reply letter received, please apply to another company",
                      animationDuration: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 1650),
                      backgroundColor: Color.fromARGB(255, 70, 116, 222),
                      colorText: Colors.white,
                      borderWidth: 5.0,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(20.0),
                      icon: const Icon(CupertinoIcons.info_circle));
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 70, 116, 222),
                  ),
                ),
                child: const Text(
                  "Your reply letter is accepted",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return TextButton(
                onPressed: _submit,
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 70, 116, 222),
                  ),
                ),
                child: const Text(
                  "Send Letter",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
