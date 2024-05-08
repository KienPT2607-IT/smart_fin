import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/controllers/friend_controller.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/data/services/apis/friend_services.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class EditFriendScreen extends StatefulWidget {
  final String id;
  const EditFriendScreen({super.key, required this.id});

  @override
  State<EditFriendScreen> createState() => _EditFriendScreenState();
}

class _EditFriendScreenState extends State<EditFriendScreen> {
  late GlobalKey<FormState> _key;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneNumberCtrl;
  late TextEditingController _emailCtrl;
  late FriendController _friendCtrl;
  late FriendService _friendService;
  late Friend _friend;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _friendCtrl = FriendController();
    _friendService = FriendService();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _friend = Provider.of<FriendProvider>(context, listen: false)
        .getFriendById(widget.id)!;
    _nameCtrl = TextEditingController(text: _friend.name);
    _phoneNumberCtrl = TextEditingController(text: _friend.phoneNumber);
    _emailCtrl = TextEditingController(text: _friend.email);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Friend"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      label: const Text("Name"),
                      prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child:
                              SvgPicture.asset("assets/icons/app/id-card.svg")),
                    ),
                    validator: (value) => _friendCtrl.validateName(value),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _phoneNumberCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      label: const Text("Phone Number"),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child:
                            SvgPicture.asset("assets/icons/app/phone-flip.svg"),
                      ),
                    ),
                    validator: (value) =>
                        _friendCtrl.validatePhoneNumber(value),
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child:
                            SvgPicture.asset("assets/icons/app/envelopes.svg"),
                      ),
                    ),
                    validator: (value) => _friendCtrl.validateEmail(value),
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: _editFriend,
                    child: const Text("Edit"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editFriend() async {
    if (!_key.currentState!.validate()) {}
    bool result = await _friendService.updateFriend(
      context: context,
      id: widget.id,
      newName: _nameCtrl.text,
      newPhoneNumber: _phoneNumberCtrl.text,
      newEmail: _emailCtrl.text,
    );
    if (mounted) {
      if (!result) {
        showCustomSnackBar(
          context,
          "New friend added!",
          Constant.contentTypes["success"]!,
        );
      }
      Navigator.of(context).pop();
    }
  }
}
