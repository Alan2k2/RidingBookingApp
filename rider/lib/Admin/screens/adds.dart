import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
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
  // Controllers for text input fields
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  File? _selectedImage;
  bool _showSidebar = false;
  bool _isSubmitting = false;
  List<dynamic> _ads = [];

  // Replace with your backend IP or domain
  final String apiBaseUrl = "http://192.168.29.177:5000";

  @override
  void initState() {
    super.initState();
    _fetchAdvertisements();
  }

  // Fetch advertisements from backend
  Future<void> _fetchAdvertisements() async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/admin/advertisement'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _ads = json.decode(response.body);
        });
      } else {
        _showSnack("Failed to fetch ads (${response.statusCode})");
      }
    } catch (e) {
      _showSnack("Error fetching ads: $e");
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Fetch location using geolocator and geocoding
  Future<void> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _showSnack("Location permissions are denied");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          postalCodeController.text = place.postalCode ?? '';
          localityController.text = place.subLocality ?? '';
          cityController.text = place.locality ?? '';
          districtController.text = place.subAdministrativeArea ?? '';
        });
      } else {
        _showSnack("Unable to retrieve address from coordinates.");
      }
    } catch (e) {
      _showSnack("Location error: $e");
    }
  }

  // Submit the new advertisement to backend
  Future<void> _submitAdvertisement() async {
    if (_selectedImage == null ||
        postalCodeController.text.isEmpty ||
        localityController.text.isEmpty ||
        cityController.text.isEmpty ||
        districtController.text.isEmpty ||
        linkController.text.isEmpty) {
      _showSnack("Please complete all fields and select an image");
      return;
    }

    setState(() => _isSubmitting = true);

    final uri = Uri.parse("$apiBaseUrl/api/admin/advertisement");
    final request = http.MultipartRequest('POST', uri);

    request.fields['postalCode'] = postalCodeController.text;
    request.fields['locality'] = localityController.text;
    request.fields['city'] = cityController.text;
    request.fields['district'] = districtController.text;
    request.fields['link'] = linkController.text;

    final fileStream = http.ByteStream(_selectedImage!.openRead());
    final fileLength = await _selectedImage!.length();
    final ext = path.extension(_selectedImage!.path).replaceAll('.', '');
    final mimeType = ext.isEmpty ? 'jpeg' : ext;

    final multipartFile = http.MultipartFile(
      'image',
      fileStream,
      fileLength,
      filename: path.basename(_selectedImage!.path),
      contentType: MediaType('image', mimeType),
    );

    request.files.add(multipartFile);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        _showSnack("Advertisement submitted successfully!");
        _resetForm();
        _fetchAdvertisements();
      } else {
        _showSnack("Failed to submit (code ${response.statusCode})");
      }
    } catch (e) {
      _showSnack("Submission error: $e");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // Show snackbar message
  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Reset form inputs
  void _resetForm() {
    setState(() {
      _selectedImage = null;
      postalCodeController.clear();
      localityController.clear();
      cityController.clear();
      districtController.clear();
      linkController.clear();
      _showSidebar = false;
    });
  }

  // Toggle ad status between Active and Inactive
  Future<void> _updateAdStatus(String adId, String newStatus, int index) async {
    try {
      final response = await http.patch(
        Uri.parse('$apiBaseUrl/api/admin/advertisement/$adId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        final respData = json.decode(response.body);
        if (respData['success'] == true) {
          setState(() {
            _ads[index]['status'] = newStatus;
          });
          _showSnack('Status updated to $newStatus');
        } else {
          _showSnack('Failed to update status.');
        }
      } else {
        _showSnack('Status update failed: ${response.statusCode}');
      }
    } catch (e) {
      _showSnack('Error updating status: $e');
    }
  }

  // Edit ad placeholder
  void _editAd(int index) {
    _showSnack("Edit clicked for ad ${_ads[index]['city']}");
    // You can preload data here if you want to edit
  }

  // Delete ad placeholder
  Future<void> _deleteAd(int index) async {
    final adId = _ads[index]['_id'];

    try {
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/api/admin/advertisement/$adId'),
      );

      if (response.statusCode == 200) {
        final respData = json.decode(response.body);
        if (respData['success'] == true) {
          setState(() {
            _ads.removeAt(index);
          });
          _showSnack('Advertisement deleted successfully.');
        } else {
          _showSnack('Failed to delete ad.');
        }
      } else {
        _showSnack('Delete failed with status: ${response.statusCode}');
      }
    } catch (e) {
      _showSnack('Error deleting ad: $e');
    }
  }

  // Helper widget for input fields
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Advertisement'),
        actions: [
          IconButton(
            icon: Icon(_showSidebar ? Icons.close : Icons.add),
            tooltip: _showSidebar ? "Close Form" : "Add New Advertisement",
            onPressed: () => setState(() => _showSidebar = !_showSidebar),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Submitted Advertisements",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Expanded(
                child:
                    _ads.isEmpty
                        ? const Center(child: Text("No ads found."))
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _ads.length,
                          itemBuilder: (context, index) {
                            final ad = _ads[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading:
                                    ad['image'] != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.network(
                                            '$apiBaseUrl/uploads/adds/${ad['image']}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.broken_image,
                                                    ),
                                          ),
                                        )
                                        : const Icon(Icons.image_not_supported),
                                title: Text(ad['city'] ?? 'Unknown City'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ad['locality'] ?? ''),
                                    Text(ad['district'] ?? ''),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 6,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      tooltip: 'Edit',
                                      onPressed: () => _editAd(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Delete',
                                      onPressed: () => _deleteAd(index),
                                    ),
                                    Switch(
                                      value: _ads[index]['status'] == 'Active',
                                      onChanged: (bool value) {
                                        String newStatus =
                                            value ? 'Active' : 'Inactive';
                                        _updateAdStatus(
                                          _ads[index]['_id'],
                                          newStatus,
                                          index,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),

          // Sidebar Form for Adding Advertisement
          if (_showSidebar)
            Positioned(
              top: kToolbarHeight,
              right: 0,
              width: MediaQuery.of(context).size.width * 0.9,
              bottom: 0,
              child: Material(
                elevation: 10,
                color: theme.scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(
                        'Advertisement Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Postal Code', postalCodeController),
                      _buildTextField('Locality', localityController),
                      _buildTextField('City', cityController),
                      _buildTextField('District', districtController),
                      _buildTextField(
                        'Advertisement Link (YouTube, Website, etc.)',
                        linkController,
                        inputType: TextInputType.url,
                      ),
                      const SizedBox(height: 20),

                      // Image selection button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text("Select Image / GIF"),
                        onPressed: _pickImage,
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Location fetch button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.location_on),
                        label: const Text("Get Location Automatically"),
                        onPressed: _fetchLocation,
                      ),

                      const SizedBox(height: 24),

                      // Submit button with loading indicator
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isSubmitting ? null : _submitAdvertisement,
                          child:
                              _isSubmitting
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text("Add Advertisement"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
