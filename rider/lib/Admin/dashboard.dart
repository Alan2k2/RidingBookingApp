import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard", style: TextStyle(fontSize: 24)),
      ),
      drawer: _buildDrawer(context, isDark),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 25,
                mainAxisSpacing: 15,
                children: [
                  _buildDashboardCard(
                    icon: LucideIcons.users,
                    label: "Users",
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/admin/users'),
                  ),
                  _buildDashboardCard(
                    icon: LucideIcons.truck,
                    label: "Riders",
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/admin/riders'),
                  ),
                  _buildDashboardCard(
                    icon: LucideIcons.fileImage,
                    label: "Adds",
                    color: Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/admin/adds'),
                  ),
                  _buildDashboardCard(
                    icon: LucideIcons.fileText,
                    label: "Orders",
                    color: Colors.purple,
                    onTap: () => Navigator.pushNamed(context, '/admin/orders'),
                  ),
                  _buildDashboardCard(
                    icon: LucideIcons.settings,
                    label: "Settings",
                    color: Colors.teal,
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    icon: LucideIcons.logOut,
                    label: "Logout",
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildSmallRevenueCard(context, "Riding Revenue", [
                    FlSpot(0, 1100),
                    FlSpot(1, 1500),
                    FlSpot(2, 1300),
                    FlSpot(3, 1700),
                    FlSpot(4, 1600),
                    FlSpot(5, 1900),
                    FlSpot(6, 2100),
                  ], Colors.blue),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildSmallRevenueCard(context, "Saras Revenue", [
                    FlSpot(0, 800),
                    FlSpot(1, 1100),
                    FlSpot(2, 1000),
                    FlSpot(3, 1200),
                    FlSpot(4, 1500),
                    FlSpot(5, 1800),
                    FlSpot(6, 2000),
                  ], Colors.deepPurple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRevenueCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallRevenueCard(
    BuildContext context,
    String title,
    List<FlSpot> spots,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isDark
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.transparent,
                titlesData: _buildTitlesData(context),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: theme.dividerColor, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isDark
                ? []
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Revenue", style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "₹12,450",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "(last 7 days)",
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.transparent,
                titlesData: _buildTitlesData(context),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: theme.dividerColor, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3000),
                      FlSpot(1, 4000),
                      FlSpot(2, 3500),
                      FlSpot(3, 5000),
                      FlSpot(4, 4500),
                      FlSpot(5, 7000),
                      FlSpot(6, 6800),
                    ],
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.green,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontSize: 10,
      color: isDark ? Colors.white : Colors.black,
    );

    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(days[value.toInt() % 7], style: textStyle),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1000,
          reservedSize: 35,
          getTitlesWidget:
              (value, meta) => Text("₹${value.toInt()}", style: textStyle),
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Drawer _buildDrawer(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Text(
              'Admin Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(LucideIcons.users),
            title: const Text('Users'),
            onTap: () => Navigator.pushNamed(context, '/admin/users'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.truck),
            title: const Text('Riders'),
            onTap: () => Navigator.pushNamed(context, '/admin/riders'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.package),
            title: const Text('Products'),
            onTap: () => Navigator.pushNamed(context, '/admin/products'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.fileText),
            title: const Text('Orders'),
            onTap: () => Navigator.pushNamed(context, '/admin/orders'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.logOut),
            title: const Text('Logout'),
            onTap:
                () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/auth',
                  (_) => false,
                ),
          ),
        ],
      ),
    );
  }
}
