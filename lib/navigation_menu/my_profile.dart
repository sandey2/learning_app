import 'package:flutter/material.dart';
import 'package:learning/MyProfile/edit_email.dart';
import 'package:learning/MyProfile/edit_phone.dart';
import 'package:learning/MyProfile/edit_uername.dart';
import 'package:learning/app_colors.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: AppColors.blue,
        ),
        body: Form(
          key: _keyform,
          child: Column(
            children: <Widget>[

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60, // Adjust the size as needed
                          backgroundImage: AssetImage('assets/images/userimg.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Handle camera action (e.g., open image picker)
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 24,
                                color: Colors.white, // Changed color here
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Fullname',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Text(
                        'User Type:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person_outline, color: AppColors.blue),
                            title: const Text('Username'),
                            subtitle: const Text('Ngam Sandey'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditUsername(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.email_outlined, color: AppColors.blue),
                            title: const Text('Email'),
                            subtitle: const Text('sandey@gmail.com'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditEmail(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone_outlined, color: AppColors.blue),
                            title: const Text('Phone'),
                            subtitle: const Text('077601502'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditPhone(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
                      // Save profile changes
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.icons_color),
                  ),
                ),
              ),
              const Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}