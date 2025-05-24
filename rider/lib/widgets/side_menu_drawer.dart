import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auto_page.dart';
import '../screens/bike_page.dart';
import '../screens/car_page.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';
import '../screens/login.dart'; // AuthPage

import '../Admin/dashboard.dart';
import '../Rider/dashboard.dart';

class SideMenuDrawer extends StatefulWidget {
  const SideMenuDrawer({Key? key}) : super(key: key);

  @override
  _SideMenuDrawerState createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    username();
  }

  Future<void> username() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? 'User';
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        await http.post(
          Uri.parse('http://your-server-ip:3000/api/logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
        await prefs.clear();
      } catch (e) {
        print('Logout error: $e');
      }
    } else {
      await prefs.clear();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome, $userName',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_transit,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Auto',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AutoPage()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_bike,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Bike',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BikePage()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.directions_car,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Car',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CarPage()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsPage()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.login_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Login',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AuthPage()),
                ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.dashboard_customize_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Admin',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminDashboard()),
                ),
          ),
          ListTile(
            leading: Icon(
              Icons.dashboard_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Riders',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RiderDashboard()),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
