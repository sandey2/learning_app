import 'package:flutter/material.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/app_url.dart';
import 'package:learning/menu/navigation_menu.dart';
import 'package:learning/screens/category_screen.dart';
import 'package:learning/screens/contact_screen.dart';
import 'package:learning/screens/favorite_items.dart';
import 'package:learning/screens/group_screen.dart';
import 'package:learning/screens/help_screen.dart';
import 'package:learning/screens/my_orders.dart';
import 'package:learning/screens/new_order.dart';
import 'package:learning/screens/popular_items.dart';
import 'package:learning/screens/product_screen.dart';
import 'package:learning/screens/setting_screen.dart';
import 'package:learning/screens/top_news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDashboard extends StatefulWidget {
  const AppDashboard({super.key});

  @override
  State<AppDashboard> createState() => _AppDashboardState();
}

class _AppDashboardState extends State<AppDashboard> {
  String? _fullname;
  String? _image ="${AppUrl.url}images/default.png";
  Future<void> _loadUserInfo() async{
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _fullname = sp.getString("USER_FULLNAME") ?? 'Guest';
      _image = sp.getString("USER_IMAGE") ?? 'default.png';
    });
  }
  @override
  void initState(){
    super.initState();
    _loadUserInfo();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBU STORE'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text('New Order'),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Popular Items'),
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('Favorite Items'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  // go to New Order screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewOrder(),
                    ),
                  );
                  break;
                case 2:
                  // go to Popular Items screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PopularItems(),
                    ),
                  );
                  break;
                case 3:
                  // go to Favorite Items screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteItems(),
                    ),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      drawer: const NavigationMenu(),
      body: Container(
        color: AppColors.bgmain,
        child: Stack(
          children: <Widget>[
            // background
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            // contents
            ListView(
              children: <Widget>[
                Container(
                  height: 140,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Card(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: const Text(
                            'Good Afternoon!',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                          child:  Text(
                            _fullname ?? 'Guest',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyOrders(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'My Orders'.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TopNews(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Top News'.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ClipOval(
                                child: Image.network(
                                  "${AppUrl.url}/images/$_image",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // Card 1
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactScreen(),
                              ),
                            );
                          },
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
                                  Icons.person,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Contacts'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card 2
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GroupScreen(),
                              ),
                            );
                          },
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
                                  Icons.people,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Groups'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card 3
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductScreen(),
                              ),
                            );
                          },
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
                                  Icons.shopping_cart,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Products'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card 4
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoryScreen(),
                              ),
                            );
                          },
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
                                  Icons.playlist_add_check,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Categories'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card 5
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpScreen(),
                              ),
                            );
                          },
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
                              const SizedBox(height: 10),
                              Text(
                                'Help'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Card 6
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: Card(
                        // InkWell, InkResponse, GestureDector
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingScreen(),
                              ),
                            );
                          },
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
                                  Icons.settings,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Settings'.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
