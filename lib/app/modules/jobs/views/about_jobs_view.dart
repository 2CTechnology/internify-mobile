// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:simag_app/app/modules/jobs/controllers/fetch_jobs_controller.dart';
import 'package:simag_app/app/modules/timeline/controllers/post_jobs_controller.dart';
import 'package:simag_app/app/routes/app_pages.dart';
// import 'package:simag_app/app/routes/app_pages.dart';
import '../controllers/jobs_controller.dart';
import '../views/page1_about.dart';
import '../views/page2_about.dart';

class AboutJobs extends GetView<JobsController> {
  const AboutJobs({super.key});

  @override
  Widget build(BuildContext context) {
    final FetchJobsByIdController fetchController = Get.find();
    fetchController.fetchJobsById();

    // void _apply() {
    //   Get.toNamed(
    //     Routes.APPLY_JOBS,
    //     // arguments: {
    //     //   'company': job.namaTempat,
    //     //   'position': job.posisi,
    //     // }
    //     );
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
        () {
          if (fetchController.jobsModel.value.message.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final job = fetchController.jobsModel.value.data;

            // void _apply() {
            //   final postController = Get.put(PostJobsController());
            //   postController.tempatMagang = job.namaTempat;
            //   postController.posisiMagang = job.posisi;
            //   Get.toNamed(Routes.APPLY_JOBS);
            // }

            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.white,
                              height: 70,
                            ),
                            Container(
                              color: Color.fromARGB(255, 242, 242, 242),
                              height: 140,
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 56,
                                backgroundImage:
                                    AssetImage("assets/images/profile.png"),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  job.posisi,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                job.namaTempat,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Obx(() => Row(
                          children: [
                            _navAbout(
                              context,
                              title: "Description",
                              margin: EdgeInsets.fromLTRB(15, 15, 7, 15),
                              onTap: 0,
                            ),
                            _navAbout(
                              context,
                              title: "Company",
                              margin: EdgeInsets.fromLTRB(7, 15, 15, 15),
                              onTap: 1,
                            )
                          ],
                        )),
                    Expanded(
                      child: PageView(
                        controller: controller.pageController,
                        onPageChanged: (index) =>
                            controller.selectedIndex.value = index,
                        children: [
                          Page1About(),
                          Page2About(),
                        ],
                      ),
                    ),
                  ],
                ),
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   bottom: 0,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
                //     color: Colors.white,
                //     height: 78,
                //     child: TextButton(
                //       onPressed: () => _apply(),
                //       style: ButtonStyle(
                //         shape: MaterialStatePropertyAll(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //         ),
                //         backgroundColor: MaterialStatePropertyAll(
                //           Color.fromARGB(255, 70, 116, 222),
                //         ),
                //       ),
                //       child: Text(
                //         "Apply Now",
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _navAbout(
    BuildContext context, {
    required EdgeInsetsGeometry margin,
    required String title,
    required int onTap,
  }) {
    return Expanded(
      child: Container(
        margin: margin,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            foregroundColor: MaterialStatePropertyAll(
              controller.selectedIndex.value == onTap
                  ? Colors.white
                  : Color.fromARGB(255, 70, 116, 222),
            ),
            backgroundColor: MaterialStatePropertyAll(
              controller.selectedIndex.value == onTap
                  ? Color.fromARGB(255, 72, 71, 156)
                  : Color.fromARGB(51, 70, 116, 222),
            ),
          ),
          onPressed: () => controller.setPage(onTap),
          child: Text(title),
        ),
      ),
    );
  }
}
