import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color backgroundGray = Color(0xFFF5F5F5);
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color darkText = Color(0xFF101010);
  static const Color bodyText = Color(0xFF64748B);
  static const Color lightText = Color(0xFF94A3B8);
}

class AppDimensions {
  static const double spacingLarge = 24.0;
  static const double spacingMedium = 16.0;
  static const double spacingSmall = 12.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeSmall = 20.0;
}

class AppIcons {
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData activeRentals = Icons.access_time_rounded;
  static const IconData dueSoon = Icons.warning_amber_rounded;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 0: Tracking, 1: Report

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            _selectedIndex == 0
                ? TrackingScreenWidget()
                : ReportsScreenWidget(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingSmall,
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? AppColors.primaryBlue
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Tracking',
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? Colors.white
                            : AppColors.bodyText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.spacingSmall),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? AppColors.primaryBlue
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Report',
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? Colors.white
                            : AppColors.bodyText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingScreenWidget extends StatefulWidget {
  @override
  _TrackingScreenWidgetState createState() => _TrackingScreenWidgetState();
}

class _TrackingScreenWidgetState extends State<TrackingScreenWidget> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> rentalItems = [
    {
      'icon': Icons.wheelchair_pickup,
      'title': 'Wheelchair Standard',
      'date': 'Due Dec 5, 2025',
      'statusText': 'Active',
      'statusBgColor': Color(0xFFEBF8FF),
      'statusTextColor': Color(0xFF1E40AF),
      'hasProgress': true,
      'progress': 0.65,
      'progressColor': AppColors.primaryBlue,
    },
    {
      'icon': Icons.assist_walker,
      'title': 'Walker',
      'date': 'Due Dec 2, 2025',
      'statusText': 'Overdue',
      'statusBgColor': Color(0xFFFEE2E2),
      'statusTextColor': Color(0xFF991B1B),
      'hasProgress': true,
      'progress': 1.0,
      'progressColor': Color(0xFFEF4444),
    },
    {
      'icon': Icons.electric_scooter,
      'title': 'Electric Scooter',
      'date': 'Reserved for Dec 8, 2025',
      'statusText': 'Reserved',
      'statusBgColor': Color(0xFFFEF3C7),
      'statusTextColor': Color(0xFFB45309),
      'hasProgress': false,
      'progress': 0.0,
      'progressColor': Colors.transparent,
    },
    {
      'icon': Icons.chair,
      'title': 'Shower Chair',
      'date': 'Returned Nov 28, 2025',
      'statusText': 'Returned',
      'statusBgColor': Color(0xFFD1FAE5),
      'statusTextColor': Color(0xFF065F46),
      'hasProgress': false,
      'progress': 0.0,
      'progressColor': Colors.transparent,
    },
  ];

  final List<Map<String, dynamic>> notificationItems = [
    {
      'icon': AppIcons.dueSoon,
      'iconBgColor': Color(0xFFFEF3C7),
      'iconColor': AppColors.primaryOrange,
      'title': 'Rental Due Soon',
      'message': 'Walker is due in 1 day',
      'time': '2 hours ago',
    },
    {
      'icon': Icons.check_circle_outline,
      'iconBgColor': Color(0xFFD1FAE5),
      'iconColor': Color(0xFF065F46),
      'title': 'Reservation Confirmed',
      'message': 'Electric Scooter reserved for Dec 8',
      'time': '5 hours ago',
    },
    {
      'icon': Icons.event_note,
      'iconBgColor': Color(0xFFEBF8FF),
      'iconColor': AppColors.primaryBlue,
      'title': 'Return Reminder',
      'message': 'Please return Wheelchair by Dec 5',
      'time': '1 day ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildStatsCards(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildFilterPills(),
          SizedBox(height: AppDimensions.spacingMedium),
          _buildRentalCards(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildRecentNotifications(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
        vertical: AppDimensions.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Care Center',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
              letterSpacing: -0.5,
            ),
          ),
          Icon(
            AppIcons.notifications,
            size: AppDimensions.iconSizeMedium,
            color: AppColors.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '7',
              'Active Rentals',
              AppColors.primaryBlue,
              Color(0xFF2563EB),
              AppIcons.activeRentals,
            ),
          ),
          SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: _buildStatCard(
              '3',
              'Due Soon',
              AppColors.primaryOrange,
              Color(0xFFEA580C),
              AppIcons.dueSoon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color startColor,
    Color endColor,
    IconData icon,
  ) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: startColor.withOpacity(0.25),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills() {
    final filters = ['All', 'Active', 'Reserved', 'Returned'];
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map((filter) => _buildFilterPill(filter, selectedFilter == filter))
            .toList(),
      ),
    );
  }

  Widget _buildFilterPill(String text, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFilter = text;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : AppColors.lightGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.bodyText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRentalCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Column(
        children: rentalItems.map((item) {
          if (selectedFilter == 'All' || item['statusText'] == selectedFilter) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.spacingSmall,
              ),
              child: _buildRentalCard(
                icon: item['icon'],
                title: item['title'],
                date: item['date'],
                statusText: item['statusText'],
                statusBgColor: item['statusBgColor'],
                statusTextColor: item['statusTextColor'],
                hasProgress: item['hasProgress'],
                progress: item['progress'],
                progressColor: item['progressColor'],
              ),
            );
          }
          return Container();
        }).toList(),
      ),
    );
  }

  Widget _buildRentalCard({
    required IconData icon,
    required String title,
    required String date,
    required String statusText,
    required Color statusBgColor,
    required Color statusTextColor,
    required bool hasProgress,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: AppDimensions.iconSizeSmall,
                color: statusTextColor,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
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
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                ),
                if (hasProgress) ...[
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation(progressColor),
                      minHeight: 8,
                    ),
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNotifications() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Notifications',
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spacingSmall),
          ...notificationItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.spacingSmall,
              ),
              child: _buildNotificationCard(
                icon: item['icon'],
                iconBgColor: item['iconBgColor'],
                iconColor: item['iconColor'],
                title: item['title'],
                message: item['message'],
                time: item['time'],
              ),
            );
          }).toList(),
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
      padding: EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: AppDimensions.iconSizeSmall,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(color: AppColors.bodyText, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: AppColors.lightText, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: AppColors.lightText),
        ],
      ),
    );
  }
}

class ReportsScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildStatsGrid(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildMostRentedEquipment(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildMonthlyTrend(),
          SizedBox(height: AppDimensions.spacingLarge),
          _buildPerformanceInsights(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMedium,
        vertical: AppDimensions.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reports & Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
              letterSpacing: -0.5,
            ),
          ),
          Icon(
            AppIcons.notifications,
            size: AppDimensions.iconSizeMedium,
            color: AppColors.bodyText,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.shopping_bag_outlined,
                  iconColor: AppColors.primaryBlue,
                  iconBgColor: Color(0xFFEFF6FF),
                  value: '156',
                  label: 'Total Rentals',
                ),
              ),
              SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle_outline,
                  iconColor: Color(0xFF22C55E),
                  iconBgColor: Color(0xFFF0FDF4),
                  value: '8',
                  label: 'Active Now',
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingSmall),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.calendar_today_outlined,
                  iconColor: AppColors.primaryOrange,
                  iconBgColor: Color(0xFFFFF7ED),
                  value: '23',
                  label: 'Reserved',
                ),
              ),
              SizedBox(width: AppDimensions.spacingSmall),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Color(0xFFEF4444),
                  iconBgColor: Color(0xFFFEF2F2),
                  value: '3',
                  label: 'Overdue',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          SizedBox(height: AppDimensions.spacingSmall),
          Text(
            value,
            style: TextStyle(
              color: AppColors.darkText,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: AppColors.bodyText, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMostRentedEquipment() {
    final equipment = [
      {
        'name': 'Wheelchair',
        'count': 45,
        'color': AppColors.primaryBlue,
        'progress': 1.0,
      },
      {
        'name': 'Walker',
        'count': 38,
        'color': Color(0xFF22C55E),
        'progress': 0.84,
      },
      {
        'name': 'Crutches',
        'count': 32,
        'color': AppColors.primaryOrange,
        'progress': 0.71,
      },
      {
        'name': 'Shower Chair',
        'count': 28,
        'color': Color(0xFFAD46FF),
        'progress': 0.62,
      },
      {
        'name': 'Hospital Bed',
        'count': 23,
        'color': Color(0xFFF6339A),
        'progress': 0.51,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, size: 20, color: AppColors.darkText),
                SizedBox(width: 8),
                Text(
                  'Most Rented Equipment',
                  style: TextStyle(
                    color: AppColors.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.spacingMedium),
            ...equipment.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.spacingSmall),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['name'] as String,
                          style: TextStyle(
                            color: AppColors.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${item['count']}',
                          style: TextStyle(
                            color: AppColors.bodyText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: item['progress'] as double,
                        backgroundColor: Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation(
                          item['color'] as Color,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrend() {
    final weeklyData = [
      {'week': 'W1', 'value': 12, 'height': 0.43},
      {'week': 'W2', 'value': 19, 'height': 0.68},
      {'week': 'W3', 'value': 15, 'height': 0.54},
      {'week': 'W4', 'value': 25, 'height': 0.89},
      {'week': 'W5', 'value': 22, 'height': 0.79},
      {'week': 'W6', 'value': 18, 'height': 0.64},
      {'week': 'W7', 'value': 28, 'height': 1.0},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Trend',
              style: TextStyle(
                color: AppColors.darkText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.spacingMedium),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyData.map((data) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${data['value']}',
                        style: TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 37.5,
                        height: 140 * (data['height'] as double),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.primaryBlue, Color(0xFF50A2FF)],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        data['week'] as String,
                        style: TextStyle(
                          color: AppColors.bodyText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMedium),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacingMedium),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFAC46FF), Color(0xFF980FFA)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Insights',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.spacingMedium),
            _buildInsightRow('Average Rental Duration', '12 days'),
            SizedBox(height: AppDimensions.spacingSmall),
            _buildInsightRow('On-time Return Rate', '94%'),
            SizedBox(height: AppDimensions.spacingSmall),
            _buildInsightRow('Customer Satisfaction', '4.8/5.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
