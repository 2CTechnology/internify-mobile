import 'package:get/get.dart';
import 'package:simag_app/app/modules/jobs/views/about_jobs_view.dart';
import 'package:simag_app/app/modules/profile/views/counseling_view.dart';
import 'package:simag_app/app/modules/timeline/views/apply_jobs_view.dart';
import 'package:simag_app/app/modules/timeline/views/surat_balasan_view.dart';
import 'package:simag_app/app/modules/jobs/views/page1_about.dart';
import 'package:simag_app/app/modules/jobs/views/page2_about.dart';
import 'package:simag_app/app/modules/profile/views/about_view.dart';
import 'package:simag_app/app/modules/profile/views/member_team_view.dart';
import 'package:simag_app/app/modules/profile/views/my_profile_view.dart';
import 'package:simag_app/app/modules/profile/views/my_team_view.dart';
import 'package:simag_app/utils/splash_screen.dart';

import '../modules/code_otp/bindings/code_otp_binding.dart';
import '../modules/code_otp/views/code_otp_view.dart';
import '../modules/first_step/bindings/first_step_binding.dart';
import '../modules/first_step/views/first_step_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation_bar/bindings/navigation_bar_binding.dart';
import '../modules/navigation_bar/views/navigation_bar_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/jobs/bindings/jobs_binding.dart';
import '../modules/jobs/views/jobs_view.dart';
import '../modules/timeline/bindings/timeline_binding.dart';
import '../modules/timeline/views/timeline_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.FIRST_STEP,
      page: () => FirstStepView(),
      binding: FirstStepBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_BAR,
      page: () => NavigationBarView(),
      binding: NavigationBarBinding(),
    ),
    GetPage(
      name: _Paths.TIMELINE,
      page: () => const TimelineView(),
      binding: TimelineBinding(),
    ),
    GetPage(
      name: _Paths.JOBS,
      page: () => const JobsView(),
      binding: JobsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_JOBS,
      page: () => const AboutJobs(),
      binding: JobsBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_JOBS_PAGE1,
      page: () => const Page1About(),
    ),
    GetPage(
      name: _Paths.ABOUT_JOBS_PAGE2,
      page: () => const Page2About(),
    ),
    GetPage(
      name: _Paths.APPLY_JOBS,
      page: () => ApplyJobs(),
    ),
    GetPage(
      name: _Paths.SURAT_BALASAN,
      page: () => const SuratBalasan(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.CODE_OTP,
      page: () => CodeOtpView(),
      binding: CodeOtpBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_PROFILE,
      page: () => const AboutView(),
    ),
    GetPage(
      name: _Paths.COUNSELING,
      page: () => const CounselingView(),
    ),
    GetPage(
      name: _Paths.MY_PROFILE,
      page: () => const MyProfileView(),
    ),
    GetPage(
      name: _Paths.MY_TEAM,
      page: () => const MyTeamView(),
    ),
    GetPage(
      name: _Paths.MEMBER_TEAM,
      page: () => const MemberTeamView(memberCount: 0),
    ),
  ];
}
