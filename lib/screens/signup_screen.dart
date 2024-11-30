import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:learning/app_url.dart';
import 'package:learning/screens/login_user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPassword = true;
  final txt = FocusNode();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for Form validation

  void togglePassword() {
    setState(() {
      isPassword = !isPassword;
      if (txt.hasPrimaryFocus) return;
      txt.canRequestFocus = false;
    });
  }

  // TextEditingControllers for text fields
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  Future<void> _registerUser(String fullname, String username, String password) async {
    var uri = Uri.parse("${AppUrl.url}register_user.php");
    EasyLoading.show(status: 'Registering...');
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.post(uri, body: {
      'FullName': fullname,
      'UserName': username,
      'Password': password,
    });
    if(!mounted) return;
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final data = jsonDecode(response.body);
      if (data['success'] == 1) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${data['msg_success']}"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginUser(),
          ),
        );
      } else {
        // Failure, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${data['msg_error']}"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send requests to server."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register Account'),
        ),
        body: Form(
          key: _formKey, // Use the Form widget
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Image.asset(
                  'assets/images/userimg.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: txtFullName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full Name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: AppColors.blue,

                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Full Name!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: txtUsername,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: AppColors.blue,

                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Username!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: txtPassword,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 32,
                      color: AppColors.blue,

                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: GestureDetector(
                        onTap: togglePassword,
                        child: Icon(
                          isPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 32,
                          color: AppColors.blue,

                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Password!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: txtConfirmPassword,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 32,
                      color: AppColors.blue,

                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: GestureDetector(
                        onTap: togglePassword,
                        child: Icon(
                          isPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 30,
                          color: AppColors.blue,

                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Confirm Password!';
                    }
                    if (value != txtPassword.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 56,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { // Check if the form is valid
                      String strName = txtFullName.text.toString().trim();
                      String strPwd = txtPassword.text.toString().trim();
                      String strfullName = txtFullName.text;
                      _registerUser(strfullName, strName, strPwd);
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white,fontSize: 20),
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
