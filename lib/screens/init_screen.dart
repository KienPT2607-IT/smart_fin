import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/screens/history_screen.dart';
import 'package:smart_fin/utilities/widgets/bottom_nav_destination.dart';
import 'package:smart_fin/screens/note_tracker_screen.dart';
import 'package:smart_fin/screens/profile_screen.dart';
import 'package:smart_fin/screens/statistics_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int _selectedIndex = 0;
  late bool _isDataFetched;
  late final List<Widget> _destinationViews;
  late User _user;
  final MoneyJarService _moneyJarService = MoneyJarService();
  final ExpenseNoteService _expNoteService = ExpenseNoteService();
  @override
  void initState() {
    super.initState();

    _isDataFetched = false;
    _destinationViews = [
      const NoteTrackerScreen(),
      HistoryScreen(
        onSelected: (value) => setState(() {
          _selectedIndex = value;
        }),
      ),
      const StatisticsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _user = Provider.of<UserProvider>(context).user;
      _moneyJarService.getJars(context: context);
      _expNoteService.getExpenseNotes(context: context);

      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/avatars/2.jpg",
                ),
              ),
              onTap: () => setState(() {
                _selectedIndex = 3;
              }),
            ),
          ),
          title: Text(_user.fullName),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.add_user),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.message),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _destinationViews[_selectedIndex],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.white,
          destinations: const [
            BottomNavDestination(
              icon: IconlyLight.edit,
              selectedIcon: IconlyBold.edit,
              label: "Note",
            ),
            BottomNavDestination(
              icon: IconlyLight.document,
              selectedIcon: IconlyBold.document,
              label: "History",
            ),
            BottomNavDestination(
              icon: IconlyLight.graph,
              selectedIcon: IconlyBold.graph,
              label: "Statistics",
            ),
            BottomNavDestination(
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
