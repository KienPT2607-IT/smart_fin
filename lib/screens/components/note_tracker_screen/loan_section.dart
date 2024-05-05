import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/models/friend.dart';
import 'package:smart_fin/utilities/widgets/cards/friend_infor_card.dart';
import 'package:smart_fin/utilities/widgets/customs/custom_avatar_chip.dart';
import 'package:smart_fin/utilities/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:smart_fin/utilities/widgets/cards/money_jar_card.dart';

class LoanSection extends StatefulWidget {
  final int sectionType;
  final List<Friend> friendList;
  final List<MoneyJarCard> moneyJarList;

  final Function onJarSelected;
  final Function(String, bool) onFriendSelected;
  const LoanSection({
    super.key,
    required this.sectionType,
    required this.friendList,
    required this.moneyJarList,
    required this.onJarSelected,
    required this.onFriendSelected,
  });

  @override
  State<LoanSection> createState() => _LoanSectionState();
}

class _LoanSectionState extends State<LoanSection> {
  late int _selectedFriend;
  late int _selectedJar;

  late String friendName;
  late String _lenderName;

  late List<FriendInforCard> friendInforList;
  @override
  void initState() {
    super.initState();

    _selectedFriend = -1;
    _selectedJar = -1;
    friendInforList =
        widget.friendList.map((each) => FriendInforCard(friend: each)).toList();

    friendName = "";
    _lenderName = "_";
  }

  void _onCustomChipSelected(String lenderName, bool isMeLender) {
    if (_selectedFriend >= 0) {
      widget.onFriendSelected(
        widget.friendList[_selectedFriend].id,
        isMeLender,
      );

      setState(() {
        _lenderName = lenderName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                const Text(
                  "Lender: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onCustomChipSelected("Me", true),
                  child: CustomAvatarChip(
                    avatar: "M",
                    name: "Me",
                    borderColor: _lenderName == "Me"
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                    width: _lenderName == "Me" ? 1.5 : 1,
                  ),
                ),
                const Gap(5),
                GestureDetector(
                  onTap: () => _onCustomChipSelected(friendName, false),
                  child: CustomAvatarChip(
                    avatar:
                        _selectedFriend >= 0 ? friendName[0].toUpperCase() : "",
                    name: friendName,
                    borderColor: _lenderName == friendName
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black,
                    width: _lenderName == friendName ? 1.5 : 1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showCustomBottomSheet(
                      context,
                      widget.sectionType,
                      friendInforList,
                      (index) {
                        widget.onFriendSelected(
                          "_",
                          false,
                        );
                        setState(() {
                          _selectedFriend = index;
                          friendName = widget.friendList[index].name;
                          _lenderName = "_";
                        });
                      },
                    );
                  },
                  icon: const Icon(IconlyLight.user),
                ),
                IconButton(
                  onPressed: () {
                    showCustomBottomSheet(
                      context,
                      widget.sectionType - 1,
                      widget.moneyJarList,
                      (index) {
                        setState(() {
                          _selectedJar = index;
                        });
                      },
                    );
                  },
                  icon: const Icon(IconlyLight.category),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.moneyJarList.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                widget.onJarSelected(widget.moneyJarList[index].moneyJar.id);
                setState(() {
                  _selectedJar = index;
                });
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: _selectedJar == index
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.2,
                          )
                        : null,
                  ),
                  child: widget.moneyJarList[index]),
            ),
          ),
        ),
      ],
    );
  }
}
