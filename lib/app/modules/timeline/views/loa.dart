import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simag_app/app/modules/timeline/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/post_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/timeline_controller.dart';

class SuratPelaksanaan extends GetView<TimelineController> {
  const SuratPelaksanaan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    @override
    final TimelineController controller = Get.put(TimelineController());
    final FetchAlurMagangController fetchAlurMagangController =
        Get.put(FetchAlurMagangController());

    // void _submit() {
    //   if (controller.validate()) {
    //     postController.filepath = controller.selectedFile.value!.path!;
    //     postController.postResponseLetter();
    //     print("Form valid and submitted");
    //   } else {
    //     if (controller.selectedFile.value == null) {
    //       Get.snackbar(
    //         "Error",
    //         "File Is Required",
    //         animationDuration: const Duration(milliseconds: 300),
    //         duration: const Duration(milliseconds: 1650),
    //         backgroundColor: Colors.red,
    //         colorText: Colors.white,
    //         borderWidth: 5.0,
    //         snackPosition: SnackPosition.BOTTOM,
    //         margin: const EdgeInsets.all(20.0),
    //         icon: const Icon(CupertinoIcons.info_circle),
    //       );
    //     }
    //     print("Form not valid");
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Assignment Letter",
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
        if (fetchAlurMagangController
                .alurMagangModel.value.data.dataAlurMagang?.suratPelaksanaan ==
            'surat pelaksanaan telah dibuat') {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.info_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Surat pelaksanaan telah dibuat, silahkan ambil surat pelaksanaan di ruangan admin",
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
        } else {
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
                    "Surat balasan sudah diterima, silahkan tunggu hingga surat pelaksanaan diterbitkan oleh admin",
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
        }
      }),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
      //   color: Colors.white,
      //   height: 78,
      //   child: TextButton(
      //     onPressed: _submit,
      //     style: ButtonStyle(
      //       shape: MaterialStatePropertyAll(
      //         RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //       ),
      //       backgroundColor: const MaterialStatePropertyAll(
      //         Color.fromARGB(255, 70, 116, 222),
      //       ),
      //     ),
      //     child: const Text(
      //       "-",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ),
    );
  }
}
