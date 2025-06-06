import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // text & icons color in app bar
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Colors.black45,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      themeMode: ThemeMode.system, // switch based on system theme
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String profilePicUrl =
      'https://www.example.com/profile.jpg'; // Replace with actual URL
  final String name = 'John Doe';
  final String title = 'Software Engineer';
  final String bio =
      'A passionate software engineer with expertise in mobile and web development.';
  final String phone = '+1 234 567 890';
  final String email = 'johndoe@example.com';

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final iconColor = theme.appBarTheme.iconTheme?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        // appBar background and foreground colors are from ThemeData.appBarTheme
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: iconColor),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(profilePicUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor?.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              bio,
              style: TextStyle(
                fontSize: 16,
                color: textColor?.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, color: iconColor.withOpacity(0.6)),
                SizedBox(width: 8),
                Text(phone, style: TextStyle(fontSize: 16, color: textColor)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: iconColor.withOpacity(0.6)),
                SizedBox(width: 8),
                Text(email, style: TextStyle(fontSize: 16, color: textColor)),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Recent Trips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10),
            _buildTripCard(context, 'Trip to Mall', 'Mall', 200),
            SizedBox(height: 10),
            _buildTripCard(context, 'Trip to Airport', 'Airport', 500),
          ],
        ),
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context,
    String title,
    String destination,
    int fare,
  ) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final iconColor = theme.iconTheme.color ?? Colors.black;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: iconColor),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Destination: $destination',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor?.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Fare: ₹$fare',
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward, color: iconColor),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = 'John Doe';
    titleController.text = 'Software Engineer';
    bioController.text =
        'A passionate software engineer with expertise in mobile and web development.';
    phoneController.text = '+1 234 567 890';
    emailController.text = 'johndoe@example.com';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium?.color;
    final inputDecoration = InputDecoration(
      labelStyle: TextStyle(color: textColor?.withOpacity(0.7)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: textColor?.withOpacity(0.3) ?? Colors.grey,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: theme.primaryColor),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: inputDecoration.copyWith(labelText: 'Name'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: inputDecoration.copyWith(labelText: 'Title'),
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bioController,
              decoration: inputDecoration.copyWith(labelText: 'Bio'),
              style: TextStyle(color: textColor),
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: inputDecoration.copyWith(labelText: 'Phone'),
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: inputDecoration.copyWith(labelText: 'Email'),
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save updated profile data and pop
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
