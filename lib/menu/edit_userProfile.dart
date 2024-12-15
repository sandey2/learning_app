import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  TextEditingController controllerusername = TextEditingController();
  TextEditingController controllerfullname = TextEditingController();
  TextEditingController controllerphone = TextEditingController();
  TextEditingController controlleremail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      controllerusername.text = sp.getString("USER_NAME") ?? '';
      controllerfullname.text = sp.getString("USER_FULLNAME") ?? '';
      controllerphone.text = sp.getString("USER_PHONE") ?? '';
      controlleremail.text = sp.getString("USER_EMAIL") ?? '';
    });
  }

  Future<void> _updateUser(String username, String fullname, String phone, String email) async {
    EasyLoading.show(status: 'Updating...');

    // Retrieve the user ID from SharedPreferences
    final sp = await SharedPreferences.getInstance();
    int userId = sp.getInt("USER_ID")!;  // Assuming the user ID is stored in SharedPreferences

    // Define the URL
    var url = Uri.parse("${AppUrl.url}update_users_profile.php");

    // Send the POST request
    var response = await http.post(url, body: {
      'userID': userId.toString(),  // Pass the user ID here
      'username': username,
      'fullname': fullname,
      'phone': phone,
      'email': email,
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['success'] == 1) {
        // Save to SharedPreferences if the update is successful
        await sp.setString("USER_NAME", username);
        await sp.setString("USER_FULLNAME", fullname);
        await sp.setString("USER_PHONE", phone);
        await sp.setString("USER_EMAIL", email);

        EasyLoading.showSuccess('Profile updated successfully!');
        Navigator.pop(context, {
          'username': username,
          'fullname': fullname,
          'phone': phone,
          'email': email,
        });
      } else {
        EasyLoading.showError('Failed to update profile');
      }
    } else {
      EasyLoading.showError('Failed to connect to the server');
    }
  }
  @override
  void dispose() {
    controllerusername.dispose();
    controllerfullname.dispose();
    controllerphone.dispose();
    controlleremail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Username Field
              TextFormField(
                controller: controllerusername,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Full Name Field
              TextFormField(
                controller: controllerfullname,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your fullname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              TextFormField(
                controller: controllerphone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: controlleremail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Update Button
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
                      String username = controllerusername.text.trim();
                      String fullname = controllerfullname.text.trim();
                      String phone = controllerphone.text.trim();
                      String email = controlleremail.text.trim();
                      _updateUser(username, fullname, phone, email);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
