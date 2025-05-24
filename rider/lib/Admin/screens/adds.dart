import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // Automatically follow system setting
      home: const AddAdvertisementScreen(),
    ),
  );
}

class AddAdvertisementScreen extends StatefulWidget {
  const AddAdvertisementScreen({super.key});

  @override
  State<AddAdvertisementScreen> createState() => _AddAdvertisementScreenState();
}

class _AddAdvertisementScreenState extends State<AddAdvertisementScreen> {
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();

  File? _selectedImage;
  bool _showSidebar = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          postalCodeController.text = place.postalCode ?? '';
          localityController.text = place.subLocality ?? '';
          cityController.text = place.locality ?? '';
          districtController.text = place.subAdministrativeArea ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fetch location: $e")));
    }
  }

  void _submitAdvertisement() {
    if (_selectedImage == null ||
        postalCodeController.text.isEmpty ||
        localityController.text.isEmpty ||
        cityController.text.isEmpty ||
        districtController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields and select an image"),
        ),
      );
      return;
    }

    // Example submission action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Advertisement submitted successfully!")),
    );

    // Optionally reset the form
    setState(() {
      _selectedImage = null;
      postalCodeController.clear();
      localityController.clear();
      cityController.clear();
      districtController.clear();
      _showSidebar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Advertisement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _showSidebar = !_showSidebar;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Center(
            child: Text("Click the top right menu to add advertisement"),
          ),
          if (_showSidebar)
            Positioned(
              top: kToolbarHeight,
              right: 0,
              width: MediaQuery.of(context).size.width * 0.85,
              bottom: 0,
              child: Material(
                elevation: 6,
                color: theme.scaffoldBackgroundColor,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Advertisement Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: postalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                      ),
                    ),
                    TextField(
                      controller: localityController,
                      decoration: const InputDecoration(labelText: 'Locality'),
                    ),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    TextField(
                      controller: districtController,
                      decoration: const InputDecoration(labelText: 'District'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Select Image / GIF"),
                      onPressed: _pickImage,
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 10),
                      Image.file(_selectedImage!, height: 100),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text("Auto Location Fetch"),
                      onPressed: _fetchLocation,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text("Submit Advertisement"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _submitAdvertisement,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
