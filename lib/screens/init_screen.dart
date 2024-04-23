import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/models/user.dart';
import 'package:smart_fin/data/services/apis/category_services.dart';
import 'package:smart_fin/data/services/apis/expense_note_services.dart';
import 'package:smart_fin/data/services/apis/friend_services.dart';
import 'package:smart_fin/data/services/apis/income_note_services.dart';
import 'package:smart_fin/data/services/apis/income_source_services.dart';
import 'package:smart_fin/data/services/apis/loan_note_services.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/screens/history_screen.dart';
import 'package:smart_fin/utilities/widgets/customs/bottom_nav_destination.dart';
import 'package:smart_fin/screens/note_tracker_screen.dart';
import 'package:smart_fin/screens/profile_screen.dart';
import 'package:smart_fin/screens/statistics_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  late bool _isDataFetched;
  late int _selectedScreen;
  late User _user;
  late final List<Widget> _destinationViews;
  late final MoneyJarService _moneyJarService;
  late final ExpenseNoteService _expNoteService;
  late final FriendService _friendService;
  late final LoanNoteService _loanNoteService;
  late final IncomeNoteService _incomeNoteService;
  late final IncomeSourceService _incomeSourceService;
  late final CategoryService _categoryService;

  @override
  void initState() {
    super.initState();

    _selectedScreen = 0;
    _moneyJarService = MoneyJarService();
    _expNoteService = ExpenseNoteService();
    _friendService = FriendService();
    _loanNoteService = LoanNoteService();
    _incomeNoteService = IncomeNoteService();
    _incomeSourceService = IncomeSourceService();
    _categoryService = CategoryService();

    _isDataFetched = false;
    _destinationViews = [
      const NoteTrackerScreen(),
      HistoryScreen(
        onSelected: (value) => setState(() {
          _selectedScreen = value;
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
      _expNoteService.getExpenses(context: context);
      _friendService.getFriends(context: context);
      _loanNoteService.getLoans(context: context);
      _incomeSourceService.getSources(context: context);
      _incomeNoteService.getNotes(context: context);
      _categoryService.getCategories(context: context);
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatars/2.jpg"),
              ),
              onTap: () => setState(() {
                _selectedScreen = 3;
              }),
            ),
          ),
          title: Text(_user.fullName),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              // TODO: Turn this into setting function
              icon: SvgPicture.asset("assets/icons/app/search.svg"),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: _destinationViews[_selectedScreen],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedScreen,
          onDestinationSelected: (index) {
            setState(() {
              _selectedScreen = index;
            });
          },
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.white60,
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
