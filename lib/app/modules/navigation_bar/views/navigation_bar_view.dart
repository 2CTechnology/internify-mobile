// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, must_be_immutable
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simag_app/app/modules/home/views/home_view.dart';
import 'package:simag_app/app/modules/profile/views/profile_view.dart';
import 'package:simag_app/app/modules/jobs/views/jobs_view.dart';
import 'package:simag_app/app/modules/timeline/controllers/timeline_controller.dart';
import 'package:simag_app/app/modules/timeline/views/timeline_view.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'package:get/get.dart';

import '../controllers/navigation_bar_controller.dart';

class NavigationBarView extends GetView<NavigationBarController> {
  NavigationBarView({Key? key}) : super(key: key);

  // Variables to track back button
  int _backButtonPressCount = 0;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    controller.onInit();

    return WillPopScope(
      onWillPop: () async {
        if (_backButtonPressCount == 0) {
          // start a timer to reset the count if not pressed again
          _backButtonPressCount++;
          _timer = Timer(const Duration(seconds: 1), () {
            _backButtonPressCount = 0;
          });
          // Show a snackbar or toast indicating press again to exit
          Get.snackbar(
            "Information",
            "Press again to exit",
            animationDuration: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 1650),
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            borderWidth: 5.0,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(20.0),
            icon: const Icon(CupertinoIcons.info_circle),
          );
          return false; // Do not exit the app yet
        } else {
          // Second press within the timer duration, exit the app
          _timer.cancel(); // Cancel the timer
          return true; // Allow the app to exit
        }
      },
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) {
            controller.animateToPage(index);

            // Jika index 2 adalah halaman Timeline
            if (index == 2) {
              if (Get.isRegistered<TimelineController>()) {
                Get.find<TimelineController>().fetchTimelineData();
              } else {
                Get.put(TimelineController()).fetchTimelineData();
              }
            }
          },
          controller: controller.pageController,
          physics: const BouncingScrollPhysics(),
          children: [
            HomeView(),
            const JobsView(),
            const TimelineView(),
            // GetBuilder<TimelineController>(
            //   init: TimelineController()..fetchTimelineData(),
            //   builder: (_) => const TimelineView(),
            // ),
            const ProfileView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(38, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 10.0,
              elevation: 0.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.home,
                        page: 0,
                        label: "Home",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.briefcase,
                        page: 1,
                        label: "Jobs",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.map,
                        page: 2,
                        label: "Timeline",
                      ),
                      _bottomAppBarItem(
                        context,
                        icon: CupertinoIcons.person,
                        page: 3,
                        label: "Profile",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required IconData icon,
    required int page,
    required String label,
  }) {
    return ZoomTapAnimation(
      onTap: () => controller.goToPage(page),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: controller.currentPage.value == page
                  ? const Color.fromARGB(255, 70, 116, 222)
                  : Colors.grey,
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: controller.currentPage.value == page
                      ? const Color.fromARGB(255, 70, 116, 222)
                      : Colors.grey,
                  fontSize: 13,
                  fontWeight: controller.currentPage.value == page
                      ? FontWeight.w600
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
