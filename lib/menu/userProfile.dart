import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:learning/menu/edit_userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? _username;
  String? _fullname;
  String? _phone;
  String? _email;
  String _image = 'default.png';
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _username = sp.getString("USER_NAME");
      _fullname = sp.getString("USER_FULLNAME");
      _phone = sp.getString("USER_PHONE");
      _email = sp.getString("USER_EMAIL");
      _image = sp.getString("USER_Avatar")!;
    });
  }
  Future<void> _pickImage() async {
    final sp = await SharedPreferences.getInstance();
    int? userId = sp.getInt("USER_ID");

    if (userId == null) {
      EasyLoading.showError("User ID not found!");
      return;
    }

    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      EasyLoading.showError("No image selected.");
      return;
    }

    setState(() {
      _newImage = File(file.path);
    });

    var url = Uri.parse("${AppUrl.url}change_image_profile.php");
    var request = http.MultipartRequest("POST", url);

    request.fields['userID'] = userId.toString(); // Add user ID
    request.files.add(
      await http.MultipartFile.fromPath("avatar", _newImage!.path),
    );

    EasyLoading.show(status: "Uploading...");
      final response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        final msg = json.decode(data);

        if (msg['success'] == 1) {
          EasyLoading.showSuccess(msg['message']);
          setState(() {
            _image = msg['image'] ?? 'default.png'; // Update displayed image
          });
        } else {
          EasyLoading.showError(msg['message']);
        }
      } else {
        EasyLoading.showError("Failed to send data to server");
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: topPortion(_image)),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    "$_fullname",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue, // Add your custom color here
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ACCOUNT DETAIL',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to Edit Profile Screen when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditUserProfile(),
                                ),
                              );
                            },
                            child: Text(
                              'EDIT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Username:'),
                          Text(
                            '$_username',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Full Name:'),
                          Text(
                            '$_fullname',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Phone Number:'),
                          Text(
                            '$_phone',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Email:'),
                          Text(
                            '$_email',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topPortion(String image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      width: 3.0,
                      color: AppColors.blue,
                    ),
                    shape: BoxShape.circle,
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: (_newImage !=null) ? Image.file(_newImage!) : NetworkImage('${AppUrl.url}images/$image'),
                    // ),
                  ),
                  child: ClipOval(
                    child: _newImage != null
                        ? Image.file(_newImage!, fit: BoxFit.cover)
                        : Image.network(
                      '${AppUrl.url}/images/$image',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          _pickImage();
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppColors.blue,
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
