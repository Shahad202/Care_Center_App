import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrackingScreenWidget(), // صفحتك اللي كتبتيها
    );
  }
}

class TrackingScreenWidget extends StatefulWidget {
  @override
  _TrackingScreenWidgetState createState() => _TrackingScreenWidgetState();
}

class _TrackingScreenWidgetState extends State<TrackingScreenWidget> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              _buildTopBar(),

              SizedBox(height: 18),

              // Stats Cards
              _buildStatsCards(),

              SizedBox(height: 18),

              // Filter Pills
              _buildFilterPills(),

              SizedBox(height: 18),

              // Rental Cards
              _buildRentalCards(),

              SizedBox(height: 18),

              // Recent Notifications
              _buildRecentNotifications(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Top Bar Widget
  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Care Center',
            style: TextStyle(
              color: Color.fromRGBO(10, 10, 10, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(243, 244, 246, 1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 24,
              color: Color.fromRGBO(73, 85, 101, 1),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Cards Widget
  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '7',
              'Active Rentals',
              Color.fromRGBO(59, 130, 246, 1),
              Icons.access_time,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '3',
              'Due Soon',
              Color.fromRGBO(249, 115, 22, 1),
              Icons.warning_amber_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Filter Pills Widget
  Widget _buildFilterPills() {
    final filters = ['All', 'Active', 'Reserved', 'Returned'];

    return Container(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color.fromRGBO(43, 127, 255, 1)
                      : Color.fromRGBO(243, 244, 246, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Color.fromRGBO(73, 85, 101, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Rental Cards Widget
  Widget _buildRentalCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Card 1: Wheelchair - Active with Progress
          _buildRentalCard(
            icon: Icons.wheelchair_pickup,
            iconBgColor: Color.fromRGBO(239, 246, 255, 1),
            iconColor: Color.fromRGBO(59, 130, 246, 1),
            title: 'Wheelchair Standard',
            date: 'Due Dec 5, 2025',
            status: 'Active',
            statusColor: Color.fromRGBO(239, 246, 255, 1),
            statusTextColor: Color.fromRGBO(27, 56, 142, 1),
            progress: 0.65,
            progressColor: Color.fromRGBO(43, 127, 255, 1),
            hasProgress: true,
          ),

          SizedBox(height: 12),

          // Card 2: Walker - Overdue
          _buildRentalCard(
            icon: Icons.directions_walk,
            iconBgColor: Color.fromRGBO(254, 226, 226, 1),
            iconColor: Color.fromRGBO(153, 27, 27, 1),
            title: 'Walker with Wheels',
            date: 'Due Dec 2, 2025',
            status: 'Overdue',
            statusColor: Color.fromRGBO(254, 226, 226, 1),
            statusTextColor: Color.fromRGBO(153, 27, 27, 1),
            progress: 1.0,
            progressColor: Color.fromRGBO(239, 68, 68, 1),
            hasProgress: true,
          ),

          SizedBox(height: 12),

          // Card 3: Electric Scooter - Reserved
          _buildRentalCard(
            icon: Icons.electric_scooter,
            iconBgColor: Color.fromRGBO(254, 252, 232, 1),
            iconColor: Color.fromRGBO(114, 61, 10, 1),
            title: 'Electric Scooter',
            date: 'Reserved for Dec 8, 2025',
            status: 'Reserved',
            statusColor: Color.fromRGBO(254, 243, 199, 1),
            statusTextColor: Color.fromRGBO(114, 61, 10, 1),
            hasProgress: false,
          ),

          SizedBox(height: 12),

          // Card 4: Shower Chair - Returned
          _buildRentalCard(
            icon: Icons.chair,
            iconBgColor: Color.fromRGBO(240, 253, 244, 1),
            iconColor: Color.fromRGBO(13, 83, 43, 1),
            title: 'Shower Chair',
            date: 'Returned Nov 28, 2025',
            status: 'Returned',
            statusColor: Color.fromRGBO(209, 250, 229, 1),
            statusTextColor: Color.fromRGBO(6, 95, 70, 1),
            hasProgress: false,
          ),

          SizedBox(height: 12),

          // Card 5: Hospital Bed - Active
          _buildRentalCard(
            icon: Icons.bed,
            iconBgColor: Color.fromRGBO(239, 246, 255, 1),
            iconColor: Color.fromRGBO(59, 130, 246, 1),
            title: 'Hospital Bed',
            date: 'Due Dec 10, 2025',
            status: 'Active',
            statusColor: Color.fromRGBO(239, 246, 255, 1),
            statusTextColor: Color.fromRGBO(27, 56, 142, 1),
            progress: 0.4,
            progressColor: Color.fromRGBO(43, 127, 255, 1),
            hasProgress: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRentalCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    bool hasProgress = false,
    double progress = 0.0,
    Color progressColor = Colors.blue,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Equipment Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),

              SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Color.fromRGBO(10, 10, 10, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Date
                    Text(
                      date,
                      style: TextStyle(
                        color: Color.fromRGBO(73, 85, 101, 1),
                        fontSize: 14,
                      ),
                    ),

                    // Progress Bar
                    if (hasProgress) ...[
                      SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Color.fromRGBO(229, 231, 235, 1),
                          valueColor: AlwaysStoppedAnimation(progressColor),
                          minHeight: 8,
                        ),
                      ),
                    ],

                    SizedBox(height: 12),

                    // View Details Button
                    InkWell(
                      onTap: () {
                        // Navigate to details
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              color: Color.fromRGBO(43, 127, 255, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Color.fromRGBO(43, 127, 255, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Recent Notifications Widget
  Widget _buildRecentNotifications() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Notifications',
            style: TextStyle(
              color: Color.fromRGBO(10, 10, 10, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          // Notification 1
          _buildNotificationCard(
            icon: Icons.access_time,
            iconBgColor: Color.fromRGBO(254, 243, 199, 1),
            iconColor: Color.fromRGBO(146, 64, 14, 1),
            title: 'Rental Due Soon',
            message: 'Walker with Wheels is due in 1 day',
            time: '2 hours ago',
          ),

          SizedBox(height: 12),

          // Notification 2
          _buildNotificationCard(
            icon: Icons.check_circle,
            iconBgColor: Color.fromRGBO(209, 250, 229, 1),
            iconColor: Color.fromRGBO(6, 95, 70, 1),
            title: 'Reservation Confirmed',
            message: 'Electric Scooter reserved for Dec 8',
            time: '5 hours ago',
          ),

          SizedBox(height: 12),

          // Notification 3
          _buildNotificationCard(
            icon: Icons.notifications,
            iconBgColor: Color.fromRGBO(219, 234, 254, 1),
            iconColor: Color.fromRGBO(30, 64, 175, 1),
            title: 'Return Reminder',
            message: 'Please return Wheelchair by Dec 5',
            time: '1 day ago',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),

          SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color.fromRGBO(10, 10, 10, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Color.fromRGBO(73, 85, 101, 1),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Color.fromRGBO(153, 161, 174, 1),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Arrow
          Icon(
            Icons.chevron_right,
            size: 20,
            color: Color.fromRGBO(153, 161, 174, 1),
          ),
        ],
      ),
    );
  }
}
