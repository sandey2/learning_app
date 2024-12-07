import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:learning/menu/about_us.dart';
import 'package:learning/navigation_menu/my_profile.dart';
import 'package:learning/navigation_menu/new_password.dart';
import 'package:learning/navigation_menu/current_password.dart';
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
  Future<void> _logout() async {
    final sp = await SharedPreferences.getInstance();
    // Clear the stored user data
    await sp.remove("USER_FULLNAME");
    await sp.clear();
    Navigator.pushReplacementNamed(context, '/login'); // Adjust the route name as needed
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
              child: ClipOval(
                child: Image.network('${AppUrl.url}images/$_image'),
              ),
            ),
            decoration: const BoxDecoration(color: AppColors.blue),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
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
            leading: const Icon(Icons.phone_in_talk),
            title: const Text('Contact Us'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Promotions'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text('FAQs'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_rounded),
            title: const Text('Terms of Use'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProfile(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.password),
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
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _logout();  // Call the _logout method here
            },
          ),
        ],
      ),
    );
  }
}
