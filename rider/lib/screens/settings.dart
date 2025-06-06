import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Toggle states for switches
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _privacyPolicyAccepted = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final sectionTextStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Profile Settings', sectionTextStyle),
          _buildSettingItem(
            'Edit Profile',
            Icons.edit,
            iconColor,
            textColor,
            () {
              // Navigate to edit profile screen
            },
          ),
          _buildSettingItem(
            'Change Profile Picture',
            Icons.photo_camera,
            iconColor,
            textColor,
            () {
              // Open profile picture picker
            },
          ),

          _buildSectionHeader('Notifications', sectionTextStyle),
          _buildSettingItem(
            'Push Notifications',
            Icons.notifications,
            iconColor,
            textColor,
            null,
            switchValue: _pushNotifications,
            onSwitchChanged: (val) {
              setState(() {
                _pushNotifications = val;
              });
            },
          ),
          _buildSettingItem(
            'Email Notifications',
            Icons.email,
            iconColor,
            textColor,
            null,
            switchValue: _emailNotifications,
            onSwitchChanged: (val) {
              setState(() {
                _emailNotifications = val;
              });
            },
          ),

          _buildSectionHeader('Payment', sectionTextStyle),
          _buildSettingItem(
            'Payment Methods',
            Icons.credit_card,
            iconColor,
            textColor,
            () {
              // Navigate to payment methods
            },
          ),
          _buildSettingItem(
            'Transaction History',
            Icons.history,
            iconColor,
            textColor,
            () {
              // Navigate to transaction history
            },
          ),

          _buildSectionHeader('Privacy', sectionTextStyle),
          _buildSettingItem(
            'Privacy Policy',
            Icons.lock,
            iconColor,
            textColor,
            null,
            switchValue: _privacyPolicyAccepted,
            onSwitchChanged: (val) {
              setState(() {
                _privacyPolicyAccepted = val;
              });
            },
          ),
          _buildSettingItem(
            'Change Password',
            Icons.lock_outline,
            iconColor,
            textColor,
            () {
              // Navigate to change password screen
            },
          ),

          _buildSectionHeader('About', sectionTextStyle),
          _buildSettingItem('About App', Icons.info, iconColor, textColor, () {
            // Navigate to about app screen
          }),
          _buildSettingItem(
            'Help & Support',
            Icons.help_outline,
            iconColor,
            textColor,
            () {
              // Navigate to help & support screen
            },
          ),

          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(title, style: style),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap, {
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: onTap,
      trailing:
          (switchValue != null && onSwitchChanged != null)
              ? Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: Theme.of(context).colorScheme.secondary,
              )
              : null,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // Log out logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
        child: const Text('Log Out', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        scaffoldBackgroundColor: Colors.grey[100],
        iconTheme: const IconThemeData(color: Colors.black87),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          titleMedium: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white70),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          titleMedium: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: SettingsPage(),
    ),
  );
}
