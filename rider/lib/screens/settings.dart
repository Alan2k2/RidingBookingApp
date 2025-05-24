import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        children: [
          // Profile Settings Section
          _buildSectionHeader('Profile Settings'),
          _buildSettingItem('Edit Profile', Icons.edit, () {
            // Navigate to edit profile screen
          }),
          _buildSettingItem('Change Profile Picture', Icons.photo_camera, () {
            // Open profile picture picker
          }),

          // Notification Settings Section
          _buildSectionHeader('Notifications'),
          _buildSettingItem('Push Notifications', Icons.notifications, () {
            // Navigate to push notifications settings
          }),
          _buildSettingItem('Email Notifications', Icons.email, () {
            // Navigate to email notification settings
          }),

          // Payment Settings Section
          _buildSectionHeader('Payment'),
          _buildSettingItem('Payment Methods', Icons.credit_card, () {
            // Navigate to payment methods
          }),
          _buildSettingItem('Transaction History', Icons.history, () {
            // Navigate to transaction history
          }),

          // Privacy Settings Section
          _buildSectionHeader('Privacy'),
          _buildSettingItem('Privacy Policy', Icons.lock, () {
            // Navigate to privacy policy
          }),
          _buildSettingItem('Change Password', Icons.lock_outline, () {
            // Navigate to change password screen
          }),

          // About Section
          _buildSectionHeader('About'),
          _buildSettingItem('About App', Icons.info, () {
            // Navigate to about app screen
          }),
          _buildSettingItem('Help & Support', Icons.help_outline, () {
            // Navigate to help & support screen
          }),

          // Log Out Button
          _buildLogoutButton(),
        ],
      ),
    );
  }

  // Section header widget
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Individual setting item widget
  Widget _buildSettingItem(String title, IconData icon, Function onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(title),
      onTap: () => onTap(),
    );
  }

  // Logout button widget
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Log out logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 14.0),
        ),
        child: Text('Log Out', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.black87,
      ),
      themeMode:
          ThemeMode
              .system, // Automatically switch between dark and light mode based on the system settings
      home: SettingsPage(),
    ),
  );
}
