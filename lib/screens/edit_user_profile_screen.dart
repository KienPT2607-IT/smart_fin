import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_date_picker.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class EditUserProfileScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime dob;
  final String gender;
  const EditUserProfileScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
  });

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late GlobalKey<FormState> _key;
  late AuthService _authService;

  late TextEditingController _emailCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneNumberCtrl;
  late TextEditingController _dobCtrl;
  late DateTime _dob;
  late String _gender;
  late bool _isDataFetched;
  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _emailCtrl = TextEditingController();
    _nameCtrl = TextEditingController();
    _phoneNumberCtrl = TextEditingController();
    _dobCtrl = TextEditingController();
    _dobCtrl.text = widget.dob.toString().split(" ")[0];
    _dob = DateTime.now();
    _gender = widget.gender;
    _isDataFetched = false;
    _key = GlobalKey();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _emailCtrl.text = widget.email;
      _nameCtrl.text = widget.fullName;
      _phoneNumberCtrl.text = widget.phoneNumber;
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit profile"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          label: Text("Name"),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              IconlyLight.profile,
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(IconlyLight.document),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dobCtrl,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Date of birth",
                                prefixIcon: const Icon(IconlyLight.calendar),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onTap: _getDatePicker,
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: DropdownMenu(
                              label: const Text("Gender"),
                              leadingIcon: const Icon(IconlyLight.heart),
                              initialSelection: _gender,
                              onSelected: (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(value: "Male", label: "Male"),
                                DropdownMenuEntry(
                                    value: "Female", label: "Female"),
                                DropdownMenuEntry(
                                    value: "Other", label: "Other"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: _phoneNumberCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          label: Text("Phone Number"),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(IconlyLight.call),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: _handleUpdateProfile,
                  child: const Text("Update"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdateProfile() async {
    bool result = await _authService.updateProfile(
      context: context,
      fullName: _nameCtrl.text,
      email: _emailCtrl.text,
      phoneNumber: _phoneNumberCtrl.text,
      dob: _dob,
      gender: _gender,
    );
    if (result && mounted) {
      showCustomSnackBar(
        context,
        "Profile updated!",
        Constant.contentTypes["success"]!,
      );
      Navigator.pop(context);
    }
  }

  void _getDatePicker() {
    showDatePickerDialog(
      context,
      CupertinoDatePicker(
        initialDateTime: _dob,
        mode: CupertinoDatePickerMode.date,
        maximumDate: DateTime.now(),
        minimumYear: DateTime.now().year - 100,
        onDateTimeChanged: (newDate) {
          setState(() {
            _dob = newDate;
            _dobCtrl.text = _dob.toString().split(" ")[0];
          });
        },
      ),
    );
  }
}
