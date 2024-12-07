import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:learning/screens/app_dashboard.dart';
import 'package:learning/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool ispassword = true;
  final txt = FocusNode();
  void togglePassword() {
    setState(() {
      ispassword = !ispassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _loginUser(String username, String password) async {
    var uri = Uri.parse("${AppUrl.url}login_user.php");
    // Show loading indicator
    EasyLoading.show(status: 'Logging in...');
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.post(uri, body: {
      'UserLoginName': username,
      'PasswordLogin': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == 1) {
        final sp = await SharedPreferences.getInstance();
        sp.setInt("USER_ID", int.parse("${data['userID']}"));
        sp.setString('USER_NAME', "${data['userName']}");
        sp.setString('USER_PWD', "${data['userPassword']}");
        sp.setString('USER_TYPE', "${data['userType']}");
        sp.setString('USER_Avatar', "${data['userAvatar']}");
        sp.setString('USER_EMAIL', "${data['userEmail']}");
        sp.setString('USER_FULLNAME', "${data['userFullName']}");
        sp.setString('USER_PHONE', "${data['userPhone']}");
        sp.setBool("IS_LOGGEDIN",true);
        EasyLoading.showSuccess("${data['msg_success']}");
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AppDashboard()),
              (route) => false, // Clears the navigation stack
        );
      } else {
        EasyLoading.showError("${data['msg_error']}");
      }
    } else {
      // Handle server connection issues
      EasyLoading.showError('Failed to connect to the server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login User'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
                child: Image.asset(
                  'assets/images/userimg.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Username!';
                    }
                    return null;
                  },
                  controller: controllerUsername,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Password!';
                    }
                    return null;
                  },
                  controller: controllerPassword,
                  obscureText: ispassword,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
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
                      )),
                ),
              ),
              Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String username = controllerUsername.text.trim();
                      String password = controllerPassword.text.trim();
                      _loginUser(username, password);
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white,fontSize: 18),
                  ),
                ),
              ),
              Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Does not have an account?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
