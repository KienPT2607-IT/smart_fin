import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_fin/data/services/apis/auth_services.dart';
import 'package:smart_fin/controllers/account_controller.dart';
import 'package:smart_fin/screens/login_screen.dart';

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

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameCtrl.text;
      final String email = _emailCtrl.text;
      final String password = _passwordCtrl.text;

      authService.register(
        context: context,
        username: username,
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        AccountController.validateEmail(value)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
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
                  validator: (value) =>
                      AccountController.validatePassword(value),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordConfirmCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePasswordConfirmation,
                  decoration: InputDecoration(
                    labelText: "confirm password",
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
                          _obscurePasswordConfirmation =
                              !_obscurePasswordConfirmation;
                        });
                      },
                      icon: Icon(
                        _obscurePasswordConfirmation
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (value) => AccountController.validatePassConf(
                      value, _passwordCtrl.text),
                ),
                const SizedBox(height: 20),
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Register"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account!"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
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
