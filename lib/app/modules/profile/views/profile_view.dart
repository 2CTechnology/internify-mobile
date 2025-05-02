// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simag_app/app/data/db_provider.dart';
import 'package:simag_app/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:simag_app/app/modules/profile/views/member_team_view.dart';
import 'package:simag_app/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int id = 0;
  String token = "";

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    int fetchedId = await DatabaseProvider().getUserId();
    String fetchedToken = await DatabaseProvider().getToken();

    setState(() {
      id = fetchedId;
      token = fetchedToken;
    });

    Provider.of<ProfileController>(context, listen: false)
        .getData(idUser: id, token: token);
  }

  String getDisplayName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0]} ${nameParts[1]}';
    }
    return nameParts[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 72, 71, 156),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Consumer<ProfileController>(
            builder: (context, profileController, child) {
          // Name User Login
          String displayName =
              getDisplayName(profileController.userData["name"] ?? "Guest");

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.png"),
                backgroundColor: Colors.transparent,
                radius: 48.5,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Team Leader",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 12,
                  )
                ],
              )
            ],
          );
        }),
      ),
      backgroundColor: Color.fromARGB(255, 249, 249, 249),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 34,
          ),
          ButtonProfile(
            btnIcon: CupertinoIcons.person_fill,
            btnText: "My Profile",
            iconColor: Color.fromARGB(255, 70, 116, 222),
            textColor: Color.fromARGB(255, 49, 46, 58),
            onPressed: () => Get.toNamed(Routes.MY_PROFILE),
          ),
          Consumer<ProfileController>(builder: (context, check, child) {
            return ButtonProfile(
              btnIcon: CupertinoIcons.group_solid,
              btnText: "My Team Profile",
              iconColor: Color.fromARGB(255, 70, 116, 222),
              textColor: Color.fromARGB(255, 49, 46, 58),
              onPressed: () async {
                var data = await check.getDataKelompok(id: id, token: token);

                if (data != null && data['anggota'] != null) {
                  Get.to(
                    () => MemberTeamView(
                      memberCount: data['anggota'].length,
                      initialMembersData: List<MemberData>.from(
                        data['anggota'].map((member) => MemberData(
                              fullname: member['nama'] ?? '',
                              nim: member['nim'] ?? '',
                              prodiId: member['id_prodi'] ?? '',
                              angkatan: member['angkatan'] ?? '',
                              golongan: member['golongan'] ?? '',
                              dateOfBirth: member['tanggal_lahir'] != null
                                  ? DateTime.parse(member['tanggal_lahir'])
                                  : null,
                              gender: member['jenis_kelamin'][0].toUpperCase() +
                                      member['jenis_kelamin']
                                          .substring(1)
                                          .toLowerCase() ??
                                  '',
                              phoneNumber: member['no_telp'] ?? '',
                              email: member['email'] ?? '',
                            )),
                      ),
                    ),
                  );
                } else {
                  Get.toNamed(Routes.MY_TEAM);
                }
              },
            );
          }),
          ButtonProfile(
            btnIcon: CupertinoIcons.calendar_circle_fill,
            btnText: "Counseling",
            iconColor: Color.fromARGB(255, 70, 116, 222),
            textColor: Color.fromARGB(255, 49, 46, 58),
            onPressed: () => Get.toNamed(Routes.COUNSELING),
          ),
          ButtonProfile(
            btnIcon: CupertinoIcons.info_circle_fill,
            btnText: "About",
            iconColor: Color.fromARGB(255, 70, 116, 222),
            textColor: Color.fromARGB(255, 49, 46, 58),
            onPressed: () => Get.toNamed(Routes.ABOUT_PROFILE),
          ),
          ButtonProfile(
            btnIcon: CupertinoIcons.square_arrow_left,
            btnText: "Logout",
            iconColor: Colors.red,
            textColor: Colors.red,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 70, 116, 222),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Reset the index
                          final navigationController =
                              Get.find<NavigationBarController>();
                          navigationController.resetToHomePage();

                          DatabaseProvider().logout();

                          Get.offAllNamed(Routes.LOGIN);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                        ),
                        child: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ButtonProfile extends StatelessWidget {
  final IconData btnIcon;
  final String btnText;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ButtonProfile({
    super.key,
    required this.btnIcon,
    required this.btnText,
    required this.iconColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(38, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, -2),
              )
            ]),
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            padding: MaterialStatePropertyAll(
              EdgeInsets.only(
                left: 20,
                top: 23,
                bottom: 23,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                btnIcon,
                color: iconColor,
                size: 28.0,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                btnText,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
