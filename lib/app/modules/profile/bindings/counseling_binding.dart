import 'package:get/get.dart';
import 'package:simag_app/app/modules/profile/controllers/counseling_controller.dart';

class CounselingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounselingController>(
      () => CounselingController(),
    );
  }
}
