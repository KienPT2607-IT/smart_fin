import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:smart_fin/data/services/apis/friend_services.dart';

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
  late FriendService _friendService;
  @override
  void initState() {
    super.initState();
    _key = GlobalKey();
    _nameCtl = TextEditingController();
    _phoneNumberCtl = TextEditingController();
    _emailCtl = TextEditingController();
    _friendService = FriendService();
  }

  void _addFriend() {
    if (!_key.currentState!.validate()) {
      // TODO:show custom snackbar to show error or warning
    }
    _friendService.addFriend(
      context: context,
      name: _nameCtl.text,
      phoneNumber: _phoneNumberCtl.text,
      email: _emailCtl.text,
    );
    Navigator.of(context).pop();
    // TODO: Call friend service to add friend then pop back
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add friend"),
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
