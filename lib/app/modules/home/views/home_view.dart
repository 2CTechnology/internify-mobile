// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unrelated_type_equality_checks, unnecessary_null_comparison

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simag_app/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:simag_app/app/data/db_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

    Provider.of<HomeController>(context, listen: false)
        .getData(idUser: id, token: token);

    Provider.of<HomeController>(context, listen: false).getStatus(token: token);
  }

  Future<void> _refreshData() async {
    await _fetchInitialData();
  }

  final List myDashboard = [
    ["Hybrid", "100", Icons.home_work, Colors.lightBlueAccent],
    ["Work From Office", "50", Icons.business, Colors.purpleAccent],
    ["Work From Home", "25", Icons.home, Colors.orangeAccent],
  ];

  String getDisplayName(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0]} ${nameParts[1]}';
    }
    return nameParts[0];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            child: Consumer<HomeController>(
                builder: (context, homeController, child) {
              // Name User Login
              String displayName =
                  getDisplayName(homeController.userData["name"] ?? "Guest");

              return RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, $displayName.",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Let’s make this day productive !",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/profile.png"),
                          backgroundColor: Colors.transparent,
                          radius: 25,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Find Your internship",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      height: 250,
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        itemCount: myDashboard.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: myDashboard[index][3],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  myDashboard[index][2],
                                  color: Colors.white,
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  myDashboard[index][1],
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  myDashboard[index][0],
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(2, index == 0 ? 2.8 : 1.4),
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Status Apply",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Consumer<HomeController>(
                        builder: (context, status, child) {
                          var message = "Not Yet In a Group";
                          var iconData = Icons.question_mark_rounded;

                          if (status.statusData != null &&
                              status.statusData["data"] != null) {
                            if (status.statusData["message"] ==
                                "Berhasil menampilkan data alur magang.") {
                              message = status.statusData["data"]["message"];
                            }

                            if (status.statusData["data"]["message"] ==
                                "Proposal awaiting confirmation from the admin or lecturer.") {
                              iconData = Icons.work;
                            }
                          }

                          return Row(
                            children: [
                              Icon(
                                iconData,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.CHATBOT),
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
