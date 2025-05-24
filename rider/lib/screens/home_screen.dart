import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/side_menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String postalCode = 'Fetching...';
  String locality = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    _getLocationAndAddress();
  }

  Future<void> _getLocationAndAddress() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        postalCode = 'Location Off';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          postalCode = 'Permission Denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        postalCode = 'Permission Denied Forever';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      String newPostalCode = place.postalCode ?? 'N/A';
      String newLocality = place.locality ?? '';
      String newCity = place.subAdministrativeArea ?? '';

      setState(() {
        postalCode = newPostalCode;
        locality = newLocality;
        city = newCity;
      });

      _savePostalCodeToBackend(newPostalCode, newLocality, newCity);
    }
  }

  Future<void> _savePostalCodeToBackend(
    String postalCode,
    String locality,
    String city,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.29.177:5000/api/admin/location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'postalCode': postalCode,
          'locality': locality,
          'city': city,
        }),
      );

      if (response.statusCode == 200) {
        print('Postal code saved successfully');
      } else {
        print('Failed to save postal code');
      }
    } catch (e) {
      print('Error saving postal code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      drawer: SideMenuDrawer(),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: textColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home', style: TextStyle(color: textColor)),
            Row(
              children: [
                Icon(Icons.location_on, color: textColor),
                SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postalCode,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    if (locality.isNotEmpty || city.isNotEmpty)
                      Text(
                        "$locality, $city",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: textColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Where to?',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: textColor),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped: Pickup location')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.my_location, color: textColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pickup',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _buildCard(
                  'Auto',
                  cardColor,
                  textColor,
                  () => Navigator.pushNamed(context, '/autoPage'),
                ),
                SizedBox(width: 12),
                _buildCard(
                  'Car',
                  cardColor,
                  textColor,
                  () => Navigator.pushNamed(context, '/carPage'),
                ),
                SizedBox(width: 12),
                _buildCard(
                  'Bike',
                  cardColor,
                  textColor,
                  () => Navigator.pushNamed(context, '/bikePage'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildCard(
                  'Reserve',
                  cardColor,
                  textColor,
                  null,
                  disabled: true,
                ),
                SizedBox(width: 12),
                _buildCard(
                  'Rental',
                  cardColor,
                  textColor,
                  null,
                  disabled: true,
                ),
                SizedBox(width: 12),
                _buildCard(
                  'Pick Up',
                  cardColor,
                  textColor,
                  null,
                  disabled: true,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://media.giphy.com/media/26tPoyDhjiJ2g7rEs/giphy.gif',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    Color? color,
    Color textColor,
    VoidCallback? onTap, {
    bool disabled = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: disabled ? Colors.grey : color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: disabled ? Colors.grey[600] : textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
