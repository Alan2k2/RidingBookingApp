import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// import '../screens/login.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Dashboard'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () {
              // Add logout logic
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildSummary(context),
            const SizedBox(height: 20),
            _buildActiveTripCard(context),
            const SizedBox(height: 20),
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
          const ListTile(leading: Icon(Icons.person), title: Text('Profile')),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text('Trip History'),
          ),
          const ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('Wallet'),
          ),
          const ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Support'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Welcome Back,'),
            Text(
              'Rider John',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Row(
      children: [
        _summaryCard(Icons.attach_money, 'Earnings', '₹1520'),
        const SizedBox(width: 10),
        _summaryCard(Icons.check_circle, 'Trips', '12'),
      ],
    );
  }

  Widget _summaryCard(IconData icon, String label, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTripCard(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.directions_car, color: Colors.green),
        title: const Text('Active Trip'),
        subtitle: const Text('Pickup: Downtown\nDrop: Airport'),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to live trip tracking
          },
          child: const Text('View'),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      children: [
        _actionCard(Icons.play_arrow, 'Start Trip', Colors.indigo, () {
          Navigator.pushNamed(context, '/start-trip');
        }),
        _actionCard(Icons.history, 'Trip History', Colors.orange, () {
          Navigator.pushNamed(context, '/trip-history');
        }),
        _actionCard(Icons.wallet, 'Wallet', Colors.teal, () {
          Navigator.pushNamed(context, '/wallet');
        }),
        _actionCard(Icons.support_agent, 'Support', Colors.red, () {
          Navigator.pushNamed(context, '/support');
        }),
      ],
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
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
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
