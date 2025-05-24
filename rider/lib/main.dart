import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/home_screen.dart';
import 'screens/auto_page.dart'; // Import AutoPage
import 'screens/car_page.dart'; // Import CarPage
import 'screens/bike_page.dart'; // Import BikePage

import './Admin/dashboard.dart';
import './Admin/screens/user.dart';
import './Admin/screens/riders.dart';
import './Admin/screens/adds.dart';
import './Rider/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curved Nav Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              Breakpoint(start: 0, end: 449, name: MOBILE),
              Breakpoint(start: 450, end: 799, name: TABLET),
              Breakpoint(start: 800, end: 1199, name: DESKTOP),
              Breakpoint(start: 1200, end: double.infinity, name: '4K'),
            ],
          ),
      // Define Routes for your app
      routes: {
        '/': (context) => MainPage(), // Home Screen
        '/autoPage': (context) => AutoPage(), // AutoPage
        '/carPage': (context) => CarPage(), // CarPage
        '/bikePage': (context) => BikePage(), // BikePage
        '/home': (context) => HomeScreen(), // HomeScreen

        '/admin': (context) => AdminDashboard(), // Admin Dashboard
        '/admin/users': (context) => UserListScreen(), // User List Screen
        '/admin/riders': (context) => RiderListScreen(), // Rider List Screen
        '/admin/adds':
            (context) => AddAdvertisementScreen(), // Add Advertisement Screen
        '/rider': (context) => RiderDashboard(), // Rider Dashboard
      },
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;

  // List of screens for bottom navigation or other purposes
  final List<Widget> _screens = [
    HomeScreen(),
    // Add more screens if needed, for example:
    // AutoPage(), CarPage(), etc.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_pageIndex], // Load current screen
    );
  }
}
