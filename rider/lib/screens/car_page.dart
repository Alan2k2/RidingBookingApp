import 'package:flutter/material.dart';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  // Mock data for recent riders and favorite riders
  final List<Map<String, String>> riderData = [
    {
      'name': 'John Doe',
      'phone': '+1 234 567 890',
      'destination': 'Park',
      'fare': '\₹10',
    },
    {
      'name': 'Jane Smith',
      'phone': '+1 345 678 901',
      'destination': 'Mall',
      'fare': '\₹15',
    },
    {
      'name': 'Mike Johnson',
      'phone': '+1 456 789 012',
      'destination': 'Airport',
      'fare': '\₹20',
    },
  ];

  final List<Map<String, String>> favoriteRiders = [
    {'name': 'Alice Cooper', 'phone': '+1 567 890 123'},
    {'name': 'Bob Brown', 'phone': '+1 678 901 234'},
    {'name': 'Charlie Clark', 'phone': '+1 789 012 345'},
  ];

  // To toggle the visibility of the search bar
  bool _isSearchActive = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearchActive
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: 'Search Riders'),
                  autofocus: true,
                )
                : Text('Car Page'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) {
                  _searchController.clear(); // Clear search when closing
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Rider Information Section
            Text(
              'Recent Riders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children:
                  riderData
                      .where((rider) {
                        // Filtering riders based on search query
                        return rider['name']!.toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        );
                      })
                      .map((rider) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rider['name']!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Phone: ${rider['phone']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Destination: ${rider['destination']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Fare: ${rider['fare']}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                // Call Button
                                IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: () {
                                    // Add call functionality here
                                  },
                                ),
                                // Chat Button
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  onPressed: () {
                                    // Add chat functionality here
                                  },
                                ),
                                // Book Instant Button
                                IconButton(
                                  icon: Icon(Icons.directions_car),
                                  onPressed: () {
                                    // Add book instant functionality here
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList(),
            ),
            SizedBox(height: 20),

            // Favorite Riders Section
            Text(
              'Favorite Riders\' Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children:
                  favoriteRiders.map((rider) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rider['name']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Phone: ${rider['phone']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            // Call Button
                            IconButton(
                              icon: Icon(Icons.call),
                              onPressed: () {
                                // Add call functionality here
                              },
                            ),
                            // Chat Button
                            IconButton(
                              icon: Icon(Icons.chat),
                              onPressed: () {
                                // Add chat functionality here
                              },
                            ),
                            // Book Instant Button
                            IconButton(
                              icon: Icon(Icons.directions_car),
                              onPressed: () {
                                // Add book instant functionality here
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
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
      themeMode:
          ThemeMode
              .system, // Automatically switch between dark and light mode based on the system settings
      home: CarPage(),
    ),
  );
}
