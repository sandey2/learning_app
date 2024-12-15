import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:learning/menu/about_us.dart';
import 'package:learning/menu/userProfile.dart';
import 'package:learning/navigation_menu/current_password.dart';
import 'package:learning/screens/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  String? _fullname;
  String? _email;
  String? _image = "default.png";

  Future<void> _loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _fullname = sp.getString("USER_FULLNAME");
      _email = sp.getString("USER_EMAIL");
      _image = sp.getString("USER_Avatar")!;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$_fullname'),
            accountEmail: Text('$_email'),
            currentAccountPicture: CircleAvatar(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.blue,
                child: ClipOval(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      '${AppUrl.url}images/$_image',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.blue),
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: AppColors.blue),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone_in_talk, color: AppColors.blue),
            title: const Text('Contact Us'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.notifications, color: AppColors.blue),
            title: const Text('Promotions'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.question_mark, color: AppColors.blue),
            title: const Text('FAQs'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.message, color: AppColors.blue),
            title: const Text('Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.list_alt_rounded, color: AppColors.blue),
            title: const Text('Terms of Use'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.blue),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.password, color: AppColors.blue),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrentPassword(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.blue),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUser(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
