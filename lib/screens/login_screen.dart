import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/controllers/account_controller.dart';
import 'package:smart_fin/data/services/apis/money_jar_services.dart';
import 'package:smart_fin/screens/init_screen.dart';
import 'package:smart_fin/screens/register_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formKey;

  late FocusNode _passwordFocusNode;
  late TextEditingController _usernameCtrl;
  late TextEditingController _passwordCtrl;
  late bool _obscurePassword;

  late AccountController accountController;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _passwordFocusNode = FocusNode();
    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _obscurePassword = true;
    accountController = AccountController();
    authService = AuthService();
  }

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      bool result = await authService.login(
        context: context,
        username: _usernameCtrl.text,
        password: _passwordCtrl.text,
      );
      if (mounted && result) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const InitScreen(
              startScreen: 0,
              isFirstInit: true,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                const Gap(150),
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Gap(10),
                Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(60),
                TextFormField(
                  controller: _usernameCtrl,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: const Icon(IconlyLight.profile),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      accountController.validateUsername(value),
                ),
                const Gap(10),
                TextFormField(
                  controller: _passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(IconlyLight.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: SvgPicture.asset(
                        _obscurePassword
                            ? Constant.appIcons["show"]!
                            : Constant.appIcons["hide"]!,
                      ),
                    ),
                  ),
                  validator: (value) =>
                      accountController.validatePassword(value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Forgot password",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _loginUser,
                      child: const Text("Login"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
