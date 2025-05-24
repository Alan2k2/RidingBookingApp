import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiderListScreen extends StatefulWidget {
  const RiderListScreen({super.key});

  @override
  State<RiderListScreen> createState() => _RiderListScreenState();
}

class _RiderListScreenState extends State<RiderListScreen> {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    const String url = 'http://192.168.29.177:5000/api/admin/rider-list/riders';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        setState(() {
          _users = data;
          _filteredUsers = data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Fetch error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers =
          _users.where((user) {
            final name = user['username']?.toLowerCase() ?? '';
            final phone = user['phone']?.toLowerCase() ?? '';
            return name.contains(query.toLowerCase()) ||
                phone.contains(query.toLowerCase());
          }).toList();
    });
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  Future<void> _toggleVerification(String userId, bool value, int index) async {
    final url =
        'http://192.168.29.177:5000/api/admin/rider-list/verify-rider/$userId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isVerified': value}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredUsers[index]['isVerified'] = value;
        });
      } else {
        throw Exception('Failed to update verification.');
      }
    } catch (e) {
      print('Verification error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update verification status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider List')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search by name or phone...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _filterUsers,
                    ),
                  ),
                  Expanded(
                    child:
                        _filteredUsers.isEmpty
                            ? const Center(child: Text('No users found.'))
                            : ListView.builder(
                              itemCount: _filteredUsers.length,
                              itemBuilder: (context, index) {
                                final user = _filteredUsers[index];
                                final isExpanded = _expandedIndex == index;

                                return GestureDetector(
                                  onTap: () => _toggleExpanded(index),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    elevation: isExpanded ? 4 : 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user['username'] ??
                                                          'No Name',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      user['phone'] ??
                                                          'No Phone',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(user['category'] ?? 'N/A'),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Verified",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Switch(
                                                value:
                                                    user['isVerified'] ?? false,
                                                onChanged: (value) {
                                                  _toggleVerification(
                                                    user['_id'],
                                                    value,
                                                    index,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          if (isExpanded)
                                            const SizedBox(height: 10),
                                          if (isExpanded)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Divider(),
                                                Text(
                                                  'City: ${user['place'] ?? 'N/A'}',
                                                ),
                                                Text(
                                                  'Pincode: ${user['pincode'] ?? 'N/A'}',
                                                ),
                                                Text(
                                                  'Logged At: ${user['createdAt'] ?? 'N/A'}',
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
