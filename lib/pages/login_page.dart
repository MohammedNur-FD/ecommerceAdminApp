import 'package:ecom_boni_admin/auth/firebase_auth_service.dart';
import 'package:ecom_boni_admin/custom_widgets/screen.dart';
import 'package:ecom_boni_admin/pages/dashboad_page.dart';
import 'package:ecom_boni_admin/provider/admin_check_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formlKey = GlobalKey<FormState>();
  bool _isSecurePassword = true;
  String? _email;
  String? _password;
  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScreenBackground(
        child: Center(
          child: Form(
            key: _formlKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                _icon(),
                const SizedBox(
                  height: 16,
                ),
                _adminTilte(),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                _loginFromInputSection(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _loginAdmin();
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _loginButton(),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.login)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _errorMsg(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return const Text(
      'Login',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }

  Center _errorMsg() {
    return Center(
        child: Text(
      errorMsg,
      style: const TextStyle(color: Colors.red, fontSize: 18),
    ));
  }

  Center _adminTilte() {
    return const Center(
      child: Text(
        'WELCOME ADMIN',
        style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  void _loginAdmin() async {
    if (_formlKey.currentState!.validate()) {
      _formlKey.currentState!.save();
      try {
        final user = await FirebaseAuthService.loginAdmin(_email!, _password!);
        if (user != null) {
          final isAmin =
              // ignore: use_build_context_synchronously
              await Provider.of<AdminCheckProvider>(context, listen: false)
                  .checkAmin(_email!);
          if (isAmin) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, DashboadPage.routeName);
          } else {
            setState(() {
              errorMsg = 'You are not an admin';
            });
          }
          // ignore: use_build_context_synchronously
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMsg = e.message!;
        });
      }
    }
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 120,
      ),
    );
  }

  Widget _togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(
              Icons.visibility_off,
              color: Colors.grey,
            )
          : const Icon(
              Icons.visibility,
            ),
    );
  }

  Widget _loginFromInputSection() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'this filed must not be empty';
            }
            return null;
          },
          onSaved: (value) {
            _email = value;
          },
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: 'Email',
            suffixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          obscureText: _isSecurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your correct password';
            }
            return null;
          },
          onSaved: (value) {
            _password = value;
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: 'Password',
            suffixIcon: _togglePassword(),
          ),
        ),
      ],
    );
  }
}
