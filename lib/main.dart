import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/data/services/providers/category_provider.dart';
import 'package:smart_fin/data/services/providers/expense_provider.dart';
import 'package:smart_fin/data/services/providers/friend_provider.dart';
import 'package:smart_fin/data/services/providers/income_provider.dart';
import 'package:smart_fin/data/services/providers/income_source_provider.dart';
import 'package:smart_fin/data/services/providers/loan_provider.dart';
import 'package:smart_fin/data/services/providers/money_jar_provider.dart';
import 'package:smart_fin/screens/login_screen.dart';
import 'package:smart_fin/data/services/providers/user_provider.dart';
import 'package:smart_fin/utilities/themes/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FriendProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MoneyJarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoanProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeSourceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
