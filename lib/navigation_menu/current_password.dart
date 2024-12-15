import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/navigation_menu/new_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentPassword extends StatefulWidget {
  const CurrentPassword({super.key});

  @override
  State<CurrentPassword> createState() => _CurrentPasswordState();
}

class _CurrentPasswordState extends State<CurrentPassword> {
  bool ispassword = true;
  final txt = FocusNode();
  TextEditingController controllerPassword = TextEditingController();
  final _keyform = GlobalKey<FormState>();

  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
    });
  }

  Future<void> _currentPassword(String password) async {
    final sp = await SharedPreferences.getInstance();
    String? currentpwd = sp.getString('USER_PWD'); // Retrieve the password
    if (currentpwd != null && currentpwd == password) {
      EasyLoading.showToast("Password correct");
    } else {
      // EasyLoading.showError("Your current password is invalid!");
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NewPassword()),
            (route) => false, // Clears the navigation stack
      );
    }
  }

  // Convert the password to MD5 hash
  String toMD5(String password) {
    var bytes = utf8.encode(password);
    var pwd = md5.convert(bytes);
    return pwd.toString();
  }

  @override
  void dispose() {
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Current Password'),
        ),
        body: Form(
          key: _keyform,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                child: InkWell(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(180),
                          ),
                        ),
                        child: const Icon(
                          Icons.question_mark,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      child: Center(
                        child: TextFormField(
                          controller: controllerPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Current Password!';
                            }
                            return null;
                          },
                          obscureText: ispassword,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Current Password',
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              size: 32,
                              color: AppColors.blue,
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
                              child: GestureDetector(
                                onTap: togglePassword,
                                child: Icon(
                                  ispassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 32,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_keyform.currentState!.validate()) {
                      String strpwd = controllerPassword.text.trim();
                      _currentPassword(toMD5(strpwd));
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
