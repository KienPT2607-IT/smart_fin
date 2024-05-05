import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/controllers/friend_controller.dart';
import 'package:smart_fin/data/services/apis/friend_services.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  late GlobalKey<FormState> _key;
  late TextEditingController _nameCtl;
  late TextEditingController _phoneNumberCtl;
  late TextEditingController _emailCtl;
  late FriendController _friendController;
  late FriendService _friendService;
  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _nameCtl = TextEditingController();
    _phoneNumberCtl = TextEditingController();
    _emailCtl = TextEditingController();
    // TODO: Do the validation for friend
    _friendController = FriendController();
    _friendService = FriendService();
  }

  void _addFriend() async {
    if (!_key.currentState!.validate()) {}
    bool result = await _friendService.addFriend(
      context: context,
      name: _nameCtl.text,
      phoneNumber: _phoneNumberCtl.text,
      email: _emailCtl.text,
    );
    if (mounted && result) {
      showCustomSnackBar(
        context,
        "New friend added!",
        Constant.contentTypes["success"]!,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add friend"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameCtl,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          label: const Text("Name"),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  "assets/icons/app/id-card.svg")),
                        ),
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: _phoneNumberCtl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: const Text("Phone Number"),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                                "assets/icons/app/phone-flip.svg"),
                          ),
                        ),
                      ),
                      const Gap(10),
                      TextFormField(
                        controller: _emailCtl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                                "assets/icons/app/envelopes.svg"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _addFriend,
                  child: const Text("Add"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
