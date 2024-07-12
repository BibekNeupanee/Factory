import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'login.dart';

class NavBar extends StatelessWidget {
  final List<String> menuItems = [
    'Dashboard', 'Add Order', 'Contact', 'About Us'
  ];

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username'); // Remove the saved username

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder<String>(
            future: _getUsername(),
            builder: (context, snapshot) {
              String username = snapshot.data ?? 'Unknown User';
              String name =username.toUpperCase();
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome, $name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
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
