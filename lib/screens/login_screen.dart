import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/controllers/account_controller.dart';
import 'package:smart_fin/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _obscurePassword = true;
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  final AuthService authService = AuthService();

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      authService.login(
        context: context,
        username: _usernameCtrl.text,
        password: _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 150),
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Login to your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: _usernameCtrl,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "username",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                      AccountController.validateUsername(value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    labelText: "password",
                    prefixIcon: const Icon(Icons.password_outlined),
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
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
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
