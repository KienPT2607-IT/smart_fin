import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/controllers/account_controller.dart';
import 'package:smart_fin/screens/login_screen.dart';
import 'package:smart_fin/utilities/constants/constants.dart';
import 'package:smart_fin/utilities/customs/custom_snack_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  final AuthService authService = AuthService();
  final AccountController accountController = AccountController();

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameCtrl.text;
      final String email = _emailCtrl.text;
      final String password = _passwordCtrl.text;

      bool result = await authService.register(
        context: context,
        username: username,
        email: email,
        password: password,
      );
      // TODO: Need to test again
      if (mounted && result) {
        showCustomSnackBar(
            context,
            "Account created! Login with your new credential.",
            Constant.contentTypes["success"]!);
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => const LoginScreen(),
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150),
                Text(
                  "Register",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "create new account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(60),
                // TODO: add full name field
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
                        accountController.validateUsername(value)),
                const Gap(10),
                TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(IconlyLight.message),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        accountController.validateEmail(value)),
                const Gap(10),
                TextFormField(
                  controller: _passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
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
                const Gap(10),
                TextFormField(
                  controller: _passwordConfirmCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePasswordConfirmation,
                  decoration: InputDecoration(
                    labelText: "Confirm password",
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
                          _obscurePasswordConfirmation =
                              !_obscurePasswordConfirmation;
                        });
                      },
                      icon: SvgPicture.asset(
                        _obscurePassword
                            ? Constant.appIcons["show"]!
                            : Constant.appIcons["hide"]!,
                      ),
                    ),
                  ),
                  validator: (value) => accountController.validatePassConf(
                      value, _passwordCtrl.text),
                ),
                const Gap(20),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: registerUser,
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account!"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Login"),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
