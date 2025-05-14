// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simag_app/app/data/db_provider.dart';

import '../controllers/profile_controller.dart';

class MemberTeamView extends StatefulWidget {
  final int memberCount;
  final List<MemberData>? initialMembersData;

  const MemberTeamView({
    Key? key,
    required this.memberCount,
    this.initialMembersData,
  }) : super(key: key);

  @override
  State<MemberTeamView> createState() => _MemberTeamViewState();
}

class _MemberTeamViewState extends State<MemberTeamView> {
  final List<GlobalKey<FormBuilderState>> _formKeys = [];
  final GlobalKey<FormBuilderState> _teamFormKey =
      GlobalKey<FormBuilderState>();
  int currentPage = 0;
  int id = 0;
  String token = "";
  List<MemberData> membersData = [];
  final TextEditingController _teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    final degreeProvider =
        Provider.of<ProfileController>(context, listen: false);
    degreeProvider.getDataProdi();

    // Initialize member data list based on the member count
    for (int i = 0; i < widget.memberCount; i++) {
      _formKeys.add(GlobalKey<FormBuilderState>());
    }

    if (widget.initialMembersData != null) {
      membersData = widget.initialMembersData!;
    } else {
      membersData = List<MemberData>.generate(
        widget.memberCount,
        (index) => MemberData(),
      );
    }
  }

  Future<void> _fetchInitialData() async {
    int fetchedId = await DatabaseProvider().getUserId();
    String fetchedToken = await DatabaseProvider().getToken();

    setState(() {
      id = fetchedId;
      token = fetchedToken;
    });

    Provider.of<ProfileController>(context, listen: false)
        .getNamaKelompok(id: id, token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (currentPage > 0) {
              setState(() {
                currentPage--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            "Team Member",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            children: [
              Text(
                "Member ${currentPage + 1}",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              if (currentPage == 0) ...[
                Consumer<ProfileController>(
                  builder: (context, profileController, child) {
                    var teamData = profileController.teamName;
                    if (_teamNameController.text.isEmpty && teamData["nama_kelompok"] != null) {
                      _teamNameController.text = teamData["nama_kelompok"];
                    }
                    return FormBuilder(
                      key: _teamFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilderTextField(
                            name: "teamName",
                            controller: _teamNameController,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            decoration: InputDecoration(
                              labelText: "Team Name",
                              labelStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              hintText: "Enter team name",
                              hintStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 17,
                                horizontal: 17,
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: "Please enter a team name"),
                            ]),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ],
              IndexedStack(
                index: currentPage,
                children: List.generate(
                  widget.memberCount,
                  (index) => buildMemberForm(index),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage--;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Consumer<ProfileController>(
                      builder: (context, submit, child) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (submit.message != '') {
                        Get.snackbar(
                          "Information",
                          submit.message,
                          animationDuration: const Duration(milliseconds: 300),
                          duration: const Duration(milliseconds: 1650),
                          backgroundColor:
                              const Color.fromARGB(255, 238, 238, 238),
                          borderWidth: 5.0,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(20.0),
                          icon: const Icon(
                            CupertinoIcons.checkmark_alt_circle,
                          ),
                        );
                        submit.clear();
                      }
                    });
                    return ElevatedButton(
                      onPressed: submit.isLoading
                          ? null
                          : () async {
                              if (currentPage == 0) {
                                if (_teamFormKey.currentState!.saveAndValidate()) {
                                  _teamNameController.text =
                                      _teamFormKey.currentState!.fields['teamName']?.value ?? '';
                                } else {
                                  return;
                                }
                              }

                              // Validasi & simpan data anggota
                              if (_formKeys[currentPage].currentState!.saveAndValidate()) {
                                membersData[currentPage] =
                                    MemberData.fromFormBuilderState(_formKeys[currentPage].currentState!);

                                if (currentPage < widget.memberCount - 1) {
                                  setState(() {
                                    currentPage++;
                                  });
                                } else {
                                  if (widget.initialMembersData != null) {
                                    Provider.of<ProfileController>(context,
                                            listen: false)
                                        .getDataKelompok(id: id, token: token)
                                        .then(
                                      (data) {
                                        // Update Data Kelompok
                                        int idKelompok = data?['id'];
                                        Provider.of<ProfileController>(context,
                                                listen: false)
                                            .updateMyTeam(
                                          _teamNameController.text,
                                          membersData,
                                          idKelompok,
                                          token,
                                        );
                                      },
                                    );

                                    await _fetchInitialData();
                                  } else {
                                    // Insert Data Kelompok
                                    Provider.of<ProfileController>(context,
                                            listen: false)
                                        .insertMyTeam(
                                      _teamNameController.text,
                                      membersData,
                                      token,
                                    );
                                  }

                                  await _fetchInitialData();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: submit.isLoading
                            ? Colors.grey
                            : const Color.fromARGB(255, 70, 116, 222),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: submit.isLoading
                          ? Text(
                              "Loading ...",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : Text(
                              currentPage < widget.memberCount - 1
                                  ? "Next"
                                  : "Save",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMemberForm(int index) {
    final degreeProvider = Provider.of<ProfileController>(context);

    // Prefill form data if available
    final memberData = membersData[index];

    // Convert prodiId to degree string format
    String? initialDegree;
    if (memberData.prodiId != null) {
      initialDegree = degreeProvider.degree.firstWhere(
          (degree) => degree.startsWith('${memberData.prodiId}.'),
          orElse: () => '');
    }

    return FormBuilder(
      key: _formKeys[index],
      initialValue: {
        'Fullname': memberData.fullname,
        'NIM': memberData.nim,
        'degree': initialDegree,
        'DateOfBirth': memberData.dateOfBirth,
        'Gender': memberData.gender,
        'EmailAddress': memberData.email,
        'college': memberData.angkatan,
        'group': memberData.golongan,
        'PhoneNumber': memberData.phoneNumber,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextField(
            name: 'Fullname',
            label: 'Fullname',
            hint: 'Enter Fullname',
            validators: [FormBuilderValidators.required()],
          ),
          const SizedBox(height: 15),
          buildTextField(
            name: 'NIM',
            label: 'NIM',
            hint: 'Enter NIM',
            validators: [FormBuilderValidators.required()],
          ),
          const SizedBox(height: 15),
          degreeProvider.degree.isNotEmpty
              ? FormBuilderDropdown(
                  name: 'degree',
                  items: degreeProvider.degree
                      .map((degree) => DropdownMenuItem(
                            value: degree,
                            child: Text(degree),
                          ))
                      .toList(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Please select a degree program"),
                  ]),
                  decoration: InputDecoration(
                    labelText: "Degree Program",
                    labelStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    hintStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 17,
                      horizontal: 17,
                    ),
                  ),
                )
              : Text(
                  "Loading ...",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
          const SizedBox(height: 15),
          buildDateTimePicker(
            name: 'DateOfBirth',
            label: 'Date of Birth',
          ),
          const SizedBox(height: 15),
          buildRadioGroup(
            name: 'Gender',
            label: 'Gender',
            options: ['Male', 'Female'],
          ),
          const SizedBox(height: 15),
          buildTextField(
            name: 'EmailAddress',
            label: 'Email Address',
            hint: 'Enter Email',
            validators: [
              FormBuilderValidators.email(),
            ],
          ),
          const SizedBox(height: 15),
          buildTextField(
            name: 'college',
            label: 'College Class',
            hint: 'Enter angkatan',
            validators: [FormBuilderValidators.required()],
          ),
          const SizedBox(height: 15),
          buildTextField(
            name: 'group',
            label: 'Group Class',
            hint: 'Enter Golongan',
            validators: [FormBuilderValidators.required()],
          ),
          const SizedBox(height: 15),
          buildTextField(
            name: 'PhoneNumber',
            label: 'Phone Number',
            hint: 'Enter Phone Number',
            validators: [FormBuilderValidators.required()],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  FormBuilderTextField buildTextField({
    required String name,
    required String label,
    required String hint,
    int maxLines = 1,
    List<String? Function(String?)>? validators,
  }) {
    return FormBuilderTextField(
      name: name,
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 17,
        ),
      ),
      validator:
          validators != null ? FormBuilderValidators.compose(validators) : null,
      maxLines: maxLines,
    );
  }

  FormBuilderDateTimePicker buildDateTimePicker({
    required String name,
    required String label,
  }) {
    return FormBuilderDateTimePicker(
      name: name,
      inputType: InputType.date,
      format: DateFormat("dd/MM/yyyy"),
      style: GoogleFonts.poppins(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 17,
        ),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Please select a date"),
      ]),
    );
  }

  FormBuilderRadioGroup<String> buildRadioGroup({
    required String name,
    required String label,
    required List<String> options,
  }) {
    return FormBuilderRadioGroup<String>(
      name: name,
      options: options
          .map((option) => FormBuilderFieldOption(
                value: option,
                child: Text(option),
              ))
          .toList(),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 17,
        ),
      ),
    );
  }
}

// Define a class to hold member data
class MemberData {
  String? fullname;
  String? nim;
  int? prodiId;
  String? angkatan;
  String? golongan;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? gender;
  String? email;

  MemberData({
    this.fullname,
    this.nim,
    this.prodiId,
    this.angkatan,
    this.golongan,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.email,
  });

  bool isEmpty() {
    return fullname == null ||
        nim == null ||
        prodiId == null ||
        angkatan == null ||
        golongan == null ||
        phoneNumber == null ||
        dateOfBirth == null ||
        gender == null ||
        email == null;
  }

  factory MemberData.fromFormBuilderState(FormBuilderState state) {
    return MemberData(
      fullname: state.fields['Fullname']?.value,
      nim: state.fields['NIM']?.value,
      prodiId: int.parse(state.fields['degree']?.value.split('.').first),
      angkatan: state.fields['college']?.value,
      golongan: state.fields['group']?.value,
      phoneNumber: state.fields['PhoneNumber']?.value,
      dateOfBirth: state.fields['DateOfBirth']?.value,
      gender: state.fields['Gender']?.value,
      email: state.fields['EmailAddress']?.value,
    );
  }

  @override
  String toString() {
    return 'MemberData{fullname: $fullname, nim: $nim, prodiId: $prodiId, angkatan: $angkatan, golongan: $golongan, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, gender: $gender, email: $email}';
  }
}
