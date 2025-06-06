import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.post(
    Uri.parse('http://192.168.29.177:5000/api/auth/logout'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  // Regardless of API response, remove token
  await prefs.remove('token');

  // Navigate to login
  if (context.mounted) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () => logout(context),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, size),
            SizedBox(height: size.height * 0.03),
            _buildSummary(context, size),
            SizedBox(height: size.height * 0.03),
            _buildActiveTripCard(context),
            SizedBox(height: size.height * 0.03),
            _buildActionGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 60),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Trip History'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Wallet'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Support'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        SizedBox(width: size.width * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back', style: theme.textTheme.bodyMedium),
            Text('Rider John', style: theme.textTheme.titleMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context, Size size) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(Icons.monetization_on, 'Earnings', '₹1,520'),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: _summaryCard(Icons.check_circle_outline, 'Trips', '12'),
        ),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTripCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.directions_car, color: theme.colorScheme.primary),
        title: const Text('Active Trip'),
        subtitle: const Text('Pickup: Downtown\nDrop: Airport'),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to live trip tracking
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('View'),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final actions = [
          {
            'icon': Icons.play_arrow,
            'label': 'Start Trip',
            'color': Colors.blue,
            'route': '/start-trip',
          },
          {
            'icon': Icons.history,
            'label': 'Trip History',
            'color': Colors.orange,
            'route': '/trip-history',
          },
          {
            'icon': Icons.wallet,
            'label': 'Wallet',
            'color': Colors.teal,
            'route': '/wallet',
          },
          {
            'icon': Icons.support_agent,
            'label': 'Support',
            'color': Colors.redAccent,
            'route': '/support',
          },
        ];
        final item = actions[index];
        return _actionCard(
          item['icon'] as IconData,
          item['label'] as String,
          item['color'] as Color,
          () {
            Navigator.pushNamed(context, item['route'] as String);
          },
        );
      },
    );
  }

  Widget _actionCard(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
