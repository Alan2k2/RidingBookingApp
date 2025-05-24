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
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        cardColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey),
        cardColor: Colors.black45,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on system theme
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

  // Navigate to EditProfilePage when the user wants to edit profile
  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile, // Navigate to edit profile page
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
            ),
            SizedBox(height: 16),

            // Name and Title
            Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),

            // Bio Section
            Text(
              'Bio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(bio, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 20),

            // Contact Information Section
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: const Color.fromARGB(255, 135, 135, 135),
                ),
                SizedBox(width: 8),
                Text(phone, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: const Color.fromARGB(255, 135, 135, 135),
                ),
                SizedBox(width: 8),
                Text(email, style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 20),

            // Recent Trips Section (Uber-style activity)
            Text(
              'Recent Trips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip to Mall',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Destination: Mall',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text('Fare: ₹200', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip to Airport',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Destination: Airport',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text('Fare: ₹500', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Edit Profile Page
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the updated profile data
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
