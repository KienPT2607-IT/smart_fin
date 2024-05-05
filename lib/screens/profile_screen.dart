import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/screens/update_user_profile_screen.dart';
import 'package:smart_fin/screens/login_screen.dart';
import 'package:smart_fin/screens/veiw_category_screen.dart';
import 'package:smart_fin/screens/view_friend_screen.dart';
import 'package:smart_fin/screens/view_income_source_screen.dart';
import 'package:smart_fin/screens/view_money_jar_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  late bool _isDataFetched;

  late TextEditingController _currentPasswordCtrl;
  late TextEditingController _newPasswordCtrl;
  late TextEditingController _newPasswordConfirmCtrl;
  late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _isDataFetched = false;
    _authService = AuthService();
    _currentPasswordCtrl = TextEditingController();
    _newPasswordCtrl = TextEditingController();
    _newPasswordConfirmCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _user = Provider.of<UserProvider>(context).user;
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0XFFFDFFFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(_user.phoneNumber!),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: _handleUserProfilePicture(),
                  ),
                ],
              ),
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.profile),
              title: "Edit profile",
              onTap: _handleUpdateProfile,
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.password),
              title: "Edit password",
              onTap: _handleUpdatePassword,
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.bag),
              title: "My money jars",
              onTap: _showMoneyJarScreen,
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.bag),
              title: "My expense categories",
              onTap: _showCategoryScreen,
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.bag),
              title: "My income sources",
              onTap: _showIncomeSourceScreen,
            ),
            const Gap(10),
            _customMenuSection(
              icon: const Icon(IconlyLight.user),
              title: "My friends",
              onTap: _showFriendScreen,
            ),
            const Gap(50),
            _customMenuSection(
              icon: const Icon(
                IconlyLight.logout,
                color: Colors.red,
              ),
              title: "Sign out",
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    _authService.logout(context);
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  void _handleUpdateProfile() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UpdateUserProfileScreen(
          fullName: _user.fullName,
          email: _user.email,
          phoneNumber: _user.phoneNumber!,
          dob: _user.dob!,
          gender: _user.gender!,
        ),
      ),
    );
  }

  Widget _customMenuSection({
    required Icon icon,
    required String title,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0XFFFDFFFC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: icon,
                ),
                const Gap(20),
                Text(title),
              ],
            ),
            Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(12),
              child: const Icon(IconlyLight.arrow_right_2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _handleUserProfilePicture() {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          if (mounted) {
            _authService.updateProfilePicture(
              context: context,
              imageFile: imageFile,
            );
          }
          // final croppedFile = await ImageCropper().cropImage(
          //   sourcePath: imageFile.path,
          //   cropStyle: CropStyle.rectangle,
          // );
          // if (croppedFile != null) {
          //   imageFile = File(croppedFile.path); // Convert CroppedFile to File
          //   if (mounted) {
          //     _authService.updateProfilePicture(
          //       context: context,
          //       imageFile: imageFile,
          //     );
          //   }
          // }
        }
      },
      child: _user.profileImage!.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: SvgPicture.asset(Constant.defaultLightIcons["camera"]!),
            )
          : Image.network(_user.profileImage!),
    );
  }

  void _handleUpdatePassword() {
    _newPasswordCtrl.text = _newPasswordConfirmCtrl.text = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordCtrl,
                decoration:
                    const InputDecoration(labelText: "Current password"),
              ),
              const Gap(10),
              TextFormField(
                controller: _newPasswordCtrl,
                decoration: const InputDecoration(labelText: "New password"),
              ),
              const Gap(10),
              TextFormField(
                controller: _newPasswordConfirmCtrl,
                decoration: const InputDecoration(
                    labelText: "New password confirmation"),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    onPressed: () => _updatePassword(),
                    child: const Text('Update'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _updatePassword() {
    if (_newPasswordCtrl.text == _newPasswordConfirmCtrl.text) {
      _authService.updatePassword(
          context: context, newPassword: _newPasswordCtrl.text);
      Navigator.pop(context);
    } else {
      showCustomSnackBar(
        context,
        "New password and the confirm not match!",
        Constant.contentTypes["warning"]!,
      );
    }
  }

  void _showMoneyJarScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ViewMoneyJarScreen(),
      ),
    );
  }

  void _showCategoryScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ViewCategoryScreen(),
      ),
    );
  }

  void _showIncomeSourceScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ViewIncomeSourceScreen(),
      ),
    );
  }

  void _showFriendScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ViewFriendScreen(),
      ),
    );
  }
}
