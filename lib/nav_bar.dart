import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'login.dart';

class NavBar extends StatelessWidget {
  final List<String> menuItems = [
    'Dashboard', 'Settings', 'Contact', 'About Us'
  ];

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...menuItems.map((item) {
            return ListTile(
              title: Text(item),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(title: item),
                  ),
                );
              },
            );
          }).toList(),
          ListTile(
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
