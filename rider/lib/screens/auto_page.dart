import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class AutoPage extends StatefulWidget {
  const AutoPage({super.key});

  @override
  _AutoPageState createState() => _AutoPageState();
}

class _AutoPageState extends State<AutoPage> {
  List<Map<String, dynamic>> riderData = [];
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  final String baseUrl = 'http://192.168.29.177:5000';

  @override
  void initState() {
    super.initState();
    fetchRiders();
  }

  Future<void> fetchRiders() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/admin/rider-list/riders?category=Rider&vehicle=Auto&isVerified=true',
        ),
      );
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          riderData = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error fetching riders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch phone dialer')));
    }
  }

  Future<void> _toggleFavorite(Map<String, dynamic> rider) async {
    final newFavoriteStatus = !(rider['isFavorite'] == true);
    final riderId = rider['_id'];

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/admin/rider-list/favorite/$riderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isFavorite': newFavoriteStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          rider['isFavorite'] = newFavoriteStatus;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location services are disabled')));
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return null;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Map<String, String>?> _getUserInfoFromBackend() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/rider/getinfo'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'username': data['username'], 'phone': data['phone']};
      }
    } catch (e) {
      print("Error fetching user info from backend: $e");
    }
    return null;
  }

  Future<void> _sendLocationToRider(String riderId) async {
    final position = await _getCurrentLocation();
    if (position == null) return;

    final prefs = await SharedPreferences.getInstance();
    String? senderPhone = prefs.getString('phone');
    String? senderName = prefs.getString('username');

    if (senderPhone == null || senderName == null) {
      final userData = await _getUserInfoFromBackend();
      if (userData != null) {
        senderName = userData['username'];
        senderPhone = userData['phone'];
      }
    }

    if (senderPhone == null || senderName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to get user info')));
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/rider/chat/send-location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'riderId': riderId,
        'sender': {'name': senderName, 'phone': senderPhone},
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location sent to rider')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send location')));
    }
  }

  Widget _buildRiderCard(Map<String, dynamic> rider) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rider['username'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text('Phone: ${rider['phone']}'),
                  Text('Destination: ${rider['destination'] ?? "N/A"}'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () => _makePhoneCall(rider['phone']),
            ),
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () => _sendLocationToRider(rider['_id']),
            ),
            IconButton(
              icon: Icon(
                rider['isFavorite'] == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => _toggleFavorite(rider),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRiders =
        riderData
            .where(
              (rider) => rider['username'].toString().toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

    final favoriteRiders =
        riderData.where((rider) => rider['isFavorite'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        title:
            _isSearchActive
                ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: 'Search Riders'),
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                )
                : Text('Auto Riders'),
        actions: [
          IconButton(
            icon: Icon(_isSearchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
                if (!_isSearchActive) _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchRiders,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Riders',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.list_alt, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AutoRiderPopup(
                                    riders: riderData,
                                    onCall: _makePhoneCall,
                                    onChat: _sendLocationToRider,
                                    onFavoriteToggle: _toggleFavorite,
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (filteredRiders.isEmpty)
                      Text('No recent riders found.')
                    else
                      ...filteredRiders.map(_buildRiderCard).toList(),
                    SizedBox(height: 20),
                    Text(
                      'Favourite Riders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (favoriteRiders.isEmpty)
                      Text('No favourite riders found.')
                    else
                      ...favoriteRiders.map(_buildRiderCard).toList(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder:
                        (context) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: AnimatedSlideSheet(),
                        ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Make a Ride',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSlideSheet extends StatelessWidget {
  const AnimatedSlideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Make a Ride',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter Destination',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Ride request sent!')));
            },
            child: Text('Confirm Ride'),
          ),
        ],
      ),
    );
  }
}

class AutoRiderPopup extends StatelessWidget {
  final List<Map<String, dynamic>> riders;
  final void Function(String phone) onCall;
  final void Function(String riderId) onChat;
  final void Function(Map<String, dynamic> rider) onFavoriteToggle;

  const AutoRiderPopup({
    required this.riders,
    required this.onCall,
    required this.onChat,
    required this.onFavoriteToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 500),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Auto Riders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: riders.length,
                itemBuilder: (context, index) {
                  final rider = riders[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(rider['username'] ?? ''),
                      subtitle: Text('Phone: ${rider['phone'] ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () => onCall(rider['phone']),
                          ),
                          IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () => onChat(rider['_id']),
                          ),
                          IconButton(
                            icon: Icon(
                              rider['isFavorite'] == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () => onFavoriteToggle(rider),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
