import 'package:flutter/material.dart';
import 'package:qpoll/Admin/public_polls.dart';
import 'package:qpoll/Admin/public_result.dart';
import 'candidates_screen.dart';
import 'users_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of cards per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.2, // Aspect ratio to make cards smaller
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.person,
              title: 'Candidates',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CandidatesScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.people,
              title: 'Users',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.poll,
              title: 'Public Polls',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPublicPollsScreen()),
                );
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.output_rounded,
              title: 'Results',
              color: Colors.purple,
              onTap: () {
                // You can replace this with the actual results screen when ready
                Navigator.push(context, MaterialPageRoute(builder: (context) => PollResultsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a dashboard card with modern styling and animation
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
        required String title,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
