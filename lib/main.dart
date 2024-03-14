import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_fin/screens/init_screen.dart';
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
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // home: const LoginScreen(),
      home: const InitScreen(),
    );
  }
}
