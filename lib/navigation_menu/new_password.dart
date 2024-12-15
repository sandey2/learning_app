import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool isPasswordVisible = true;
  final txt = FocusNode();

  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  String? _password;
  String? _confirmpwd;
  final _keyform = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Future<void> _changePassword() async {
    final sp = await SharedPreferences.getInstance();
    int strId = sp.getInt("USER_ID")!;
    int strPwd = int.tryParse(controllerNewPassword.text.trim()) ?? 0;
    var url = Uri.parse("${AppUrl.url}change_password.php");
    final res = await http.post(url, body: {
      'userPassword' : strPwd,  // Send as a string
      'UserID' : strId.toString(), // Ensure strId is also a string
    });
    if(res.statusCode == 200){
      final data = jsonDecode(res.body);
      if(data['success'] == 1) {
        EasyLoading.showSuccess("${data['msg_success']}");
      }else{

      }
    }else{
      EasyLoading.showError("Faild to Send data to server!");
    }
  }

  String toMD5(String password) {
    var bytes = utf8.encode(password);
    var pwd = md5.convert(bytes);
    return pwd.toString();
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    // Optional: Add length validation or any other criteria
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password cannot be empty';
    }
    if (value != controllerNewPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Password'),
        ),
        body: Form(
          key: _keyform,
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        // controller: controllerNewPassword,
                        onChanged: (value){
                          _password = value;
                        },
                        obscureText: isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required New Password!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'New Password',
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            size: 32,
                            color: AppColors.blue,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: togglePasswordVisibility,
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 32,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextFormField(
                        onChanged: (value){
                          _confirmpwd = value;
                        },
                        obscureText: isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required Confirm Password!';
                          }
                          if(_password != _confirmpwd){
                            return 'Confirm password does not match the password.' ;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(
                            Icons.lock_outlined,
                            size: 32,
                            color: AppColors.blue,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: togglePasswordVisibility,
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 32,
                              color: AppColors.blue,
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
                      _changePassword();
                    }
                  },
                  child: const Text(
                    'Save',
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
