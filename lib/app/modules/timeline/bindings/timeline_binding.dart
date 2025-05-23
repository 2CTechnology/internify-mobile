import 'package:get/get.dart';

import '../controllers/timeline_controller.dart';

class TimelineBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TimelineController>(
      TimelineController(),
    );
  }
}
