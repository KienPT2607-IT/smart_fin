import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/common/widgets/nav_destination.dart';
import 'package:smart_fin/screens/history_screen.dart';
import 'package:smart_fin/screens/note_tracker_screen.dart';
import 'package:smart_fin/screens/profile_screen.dart';
import 'package:smart_fin/screens/statistics_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int selectedIndex = 0;
  int _selectedSegment = 0;

  final _destinationViews = <Widget>[
    const NoteTrackerScreen(),
    const HistoryScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/2.jpg",
                ),
              ),
              onTap: () => setState(() {
                selectedIndex = 3;
              }),
            ),
          ),
          title: const Text("Smart Fin"),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoSlidingSegmentedControl(
                children: const {
                  0: Icon(IconlyLight.add_user),
                  1: Icon(IconlyLight.message),
                },
                groupValue: _selectedSegment,
                onValueChanged: (newValue) => setState(() {
                  _selectedSegment = newValue!;
                }),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _destinationViews[selectedIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.white,
          destinations: const [
            NavDestination(
              icon: IconlyLight.edit,
              selectedIcon: IconlyBold.edit,
              label: "Note",
            ),
            NavDestination(
              icon: IconlyLight.document,
              selectedIcon: IconlyBold.document,
              label: "History",
            ),
            NavDestination(
              icon: IconlyLight.graph,
              selectedIcon: IconlyBold.graph,
              label: "Statistics",
            ),
            NavDestination(
              icon: IconlyLight.profile,
              selectedIcon: IconlyBold.profile,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
