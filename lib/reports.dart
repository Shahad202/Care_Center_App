import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const CareCenterApp());
}

class CareCenterApp extends StatelessWidget {
  const CareCenterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Center',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const CareCenter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CareCenter extends StatefulWidget {
  const CareCenter({Key? key}) : super(key: key);

  @override
  State<CareCenter> createState() => _CareCenterState();
}

class _CareCenterState extends State<CareCenter> {
  int _activeTab = 0;
  String _filterType = 'all';
  String _timeRange = 'month';
  bool _showFilters = false;
  bool _showTrackingFilters = false;
  String _trackingStatusFilter = 'all';
  String _trackingEquipmentFilter = 'all';
  bool _showNotificationFilters = false;
  String _notificationTypeFilter = 'all';
  String _notificationPriorityFilter = 'all';
  List<int> _dismissedNotifications = [];
  AppNotification? _selectedNotification;

  final List<RentalData> _rentalData = [
    RentalData('Wheelchairs', 45, 12),
    RentalData('Walkers', 32, 8),
    RentalData('Crutches', 28, 15),
    RentalData('Hospital Beds', 15, 5),
    RentalData('Oxygen Machines', 10, 3),
    RentalData('Others', 1, 3),
  ];

  final List<TrendData> _usageTrend = [
    TrendData('Aug', 85, 8, 3),
    TrendData('Sep', 95, 10, 4),
    TrendData('Oct', 110, 12, 6),
    TrendData('Nov', 130, 15, 8),
    TrendData('Dec', 125, 12, 5),
  ];

  final List<StatusData> _equipmentStatus = [
    StatusData('Available', 145, const Color(0xFF10b981)),
    StatusData('Rented', 85, const Color(0xFF3b82f6)),
    StatusData('Maintenance', 12, const Color(0xFFf59e0b)),
    StatusData('Reserved', 23, const Color(0xFF8b5cf6)),
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
      id: 1,
      type: 'overdue',
      title: 'Overdue Return',
      message: 'Wheelchair  is 2 days overdue',
      user: 'Ahmed Al-Khalifa',
      phone: '+973 3333 1234',
      email: 'ahmed.alkhalifa@email.com',
      checkoutDate: '2024-11-25',
      dueDate: '2024-12-03',
      time: '2 hours ago',
      priority: 'high',
      details:
          'This wheelchair was rented for elderly care. Customer has been contacted twice. Late fee: 2 BD per day.',
    ),
    AppNotification(
      id: 2,
      type: 'upcoming',
      title: 'Return Reminder',
      message: 'Walker  due tomorrow',
      user: 'Fatima Mohammed',
      phone: '+973 3333 5678',
      email: 'fatima.m@email.com',
      checkoutDate: '2024-11-28',
      dueDate: '2024-12-06',
      time: '5 hours ago',
      priority: 'medium',
      details:
          'Automated reminder sent to customer. Equipment is in good condition. Extension available upon request.',
    ),
    AppNotification(
      id: 3,
      type: 'donation',
      title: 'New Donation',
      message: 'Hospital bed donation pending approval',
      user: 'Care Foundation',
      phone: '+973 1777 8888',
      email: 'donations@carefoundation.bh',
      equipmentType: 'Hospital Bed',
      condition: 'Good',
      time: '1 day ago',
      priority: 'low',
      details:
          'Donor is a reputable charity organization. Equipment appears to be in excellent condition. Includes mattress and side rails. Requires inspection before approval.',
    ),
    AppNotification(
      id: 4,
      type: 'maintenance',
      title: 'Maintenance Required',
      message: 'Oxygen machine  needs inspection',
      user: 'System Alert',
      lastMaintenance: '2024-09-15',
      nextMaintenance: '2024-12-15',
      maintenanceType: 'Routine Inspection',
      time: '1 day ago',
      priority: 'high',
      details:
          'Equipment has completed 90 days since last maintenance. Requires pressure test and filter replacement. Currently not available for rental.',
    ),
    AppNotification(
      id: 5,
      type: 'returned',
      title: 'Equipment Returned',
      message: 'Crutches  returned successfully',
      user: 'Ali Hassan',
      phone: '+973 3333 9999',
      email: 'ali.hassan@email.com',
      checkoutDate: '2024-11-15',
      returnDate: '2024-12-03',
      time: '2 days ago',
      priority: 'low',
      details:
          'Equipment returned on time in excellent condition. No damage reported. Customer feedback: 5 stars. Available for next rental.',
    ),
  ];

  final List<ActiveRental> _activeRentals = [
    ActiveRental(
      equipment: 'Wheelchair',
      user: 'Ahmed Al-Khalifa',
      checkoutDate: '2024-11-25',
      dueDate: '2024-12-03',
      status: 'overdue',
      daysRemaining: -2,
    ),
    ActiveRental(
      equipment: 'Walker',
      user: 'Fatima Mohammed',
      checkoutDate: '2024-11-28',
      dueDate: '2024-12-06',
      status: 'due-soon',
      daysRemaining: 1,
    ),
    ActiveRental(
      equipment: 'Hospital Bed',
      user: 'Mohammed Ali',
      checkoutDate: '2024-11-20',
      dueDate: '2024-12-20',
      status: 'active',
      daysRemaining: 15,
    ),
    ActiveRental(
      equipment: 'Crutches',
      user: 'Sara Ahmed',
      checkoutDate: '2024-12-01',
      dueDate: '2024-12-15',
      status: 'active',
      daysRemaining: 10,
    ),
  ];

  List<AppNotification> get _visibleNotifications {
    return _notifications
        .where((n) => !_dismissedNotifications.contains(n.id))
        .toList();
  }

  int get _highPriorityCount {
    return _visibleNotifications.where((n) => n.priority == 'high').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
              const SizedBox(height: 70),
            ],
          ),
          _buildBottomNav(),
          if (_selectedNotification != null) _buildNotificationModal(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[600]!, Colors.indigo[700]!],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Care Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(color: Color(0xFFc7d2fe), fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to history page
                  Navigator.push(
                    context,
                    slideUpRoute(const RentalHistoryPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _activeTab == 0
          ? _buildReportsTab()
          : _activeTab == 1
          ? _buildTrackingTab()
          : _buildNotificationsTab(),
    );
  }

  Widget _buildReportsTab() {
    return Column(
      children: [
        _buildFilterButton(),
        if (_showFilters) ...[const SizedBox(height: 16), _buildFilters()],
        const SizedBox(height: 16),
        _buildMetricsGrid(),
        const SizedBox(height: 16),
        _buildEquipmentUsageChart(),
        const SizedBox(height: 16),
        _buildInventoryStatusChart(),
        const SizedBox(height: 16),
        _buildRentalTrendChart(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () => setState(() => _showFilters = !_showFilters),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_list, color: Colors.indigo),
            const SizedBox(width: 8),
            const Text(
              'Filters',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Transform.rotate(
              angle: _showFilters ? 1.57 : 0,
              child: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Range',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _timeRange,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'week', child: Text('Last Week')),
              DropdownMenuItem(value: 'month', child: Text('Last Month')),
              DropdownMenuItem(value: 'quarter', child: Text('Last Quarter')),
              DropdownMenuItem(value: 'year', child: Text('Last Year')),
            ],
            onChanged: (value) => setState(() => _timeRange = value!),
          ),
          const SizedBox(height: 16),
          const Text(
            'Equipment Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _filterType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Equipment')),
              DropdownMenuItem(value: 'rental', child: Text('Rentals Only')),
              DropdownMenuItem(
                value: 'donation',
                child: Text('Donations Only'),
              ),
            ],
            onChanged: (value) => setState(() => _filterType = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: [
        _buildMetricCard(
          'Total Rentals',
          '130',
          '↑ 12% this month',
          Colors.blue[600]!,
          Icons.inventory_2,
        ),
        _buildMetricCard(
          'Donations',
          '43',
          '↑ 8% this month',
          Colors.green[600]!,
          Icons.check_circle,
        ),
        _buildMetricCard(
          'Overdue',
          '5',
          'Needs attention',
          Colors.red[600]!,
          Icons.warning,
        ),
        _buildMetricCard(
          'Maintenance',
          '12',
          'In progress',
          Colors.orange[600]!,
          Icons.build,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 32),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentUsageChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Equipment Usage',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 50,
                barGroups: _rentalData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.rented.toDouble(),
                        color: Colors.blue,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: entry.value.donated.toDouble(),
                        color: Colors.green,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < _rentalData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _rentalData[value.toInt()].name,
                              style: const TextStyle(fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blue, 'Rented'),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.green, 'Donated'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Tips to Improve',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTipItem('Stock more wheelchairs - highest demand item'),
                _buildTipItem(
                  'Promote donation program for walkers and crutches',
                ),
                _buildTipItem('Consider purchasing more hospital beds'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryStatusChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _equipmentStatus.map((data) {
                  return PieChartSectionData(
                    value: data.value.toDouble(),
                    color: data.color,
                    title: data.value.toString(),
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: _equipmentStatus.map((item) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.name}: ${item.value}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalTrendChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rental Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 11),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < _usageTrend.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _usageTrend[value.toInt()].month,
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _usageTrend.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.rentals.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: _usageTrend.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.maintenance.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: _usageTrend.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.overdue.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.blue, 'Active Rentals'),
              const SizedBox(width: 12),
              _buildLegendItem(Colors.orange, 'Maintenance'),
              const SizedBox(width: 12),
              _buildLegendItem(Colors.red, 'Overdue'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.green[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Service Improvement Tips',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTipItem(
                  'Send automatic reminders 3 days before due date',
                ),
                _buildTipItem(
                  'Schedule preventive maintenance to reduce issues',
                ),
                _buildTipItem(
                  'Implement late fee policy to reduce overdue items',
                ),
                _buildTipItem('Offer rental extensions through mobile app'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTab() {
    // Apply filters
    List<ActiveRental> filteredRentals = _activeRentals.where((rental) {
      // Status filter
      if (_trackingStatusFilter != 'all' &&
          rental.status != _trackingStatusFilter) {
        return false;
      }

      // Equipment filter
      if (_trackingEquipmentFilter != 'all' &&
          !rental.equipment.toLowerCase().contains(
            _trackingEquipmentFilter.toLowerCase(),
          )) {
        return false;
      }

      return true;
    }).toList();

    return Column(
      children: [
        _buildTrackingFilterButton(),
        if (_showTrackingFilters) ...[
          const SizedBox(height: 16),
          _buildTrackingFilters(),
        ],
        const SizedBox(height: 16),
        _buildTrackingStats(filteredRentals),
        const SizedBox(height: 16),
        ...filteredRentals.map((rental) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rental.equipment,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(rental.status).withOpacity(0.1),
                        border: Border.all(
                          color: _getStatusColor(rental.status),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(rental.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(rental.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Customer', rental.user),
                const SizedBox(height: 8),
                _buildInfoRow('Due Date', rental.dueDate),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTimeRemainingColor(
                      rental.daysRemaining,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time Remaining',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        rental.daysRemaining < 0
                            ? '${rental.daysRemaining.abs()} days overdue'
                            : '${rental.daysRemaining} days',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getTimeRemainingColor(rental.daysRemaining),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        if (filteredRentals.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No Rentals Found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTrackingFilterButton() {
    return InkWell(
      onTap: () => setState(() => _showTrackingFilters = !_showTrackingFilters),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color:
                  (_trackingStatusFilter != 'all' ||
                      _trackingEquipmentFilter != 'all')
                  ? Colors.indigo
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Filters',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    (_trackingStatusFilter != 'all' ||
                        _trackingEquipmentFilter != 'all')
                    ? Colors.indigo
                    : Colors.black,
              ),
            ),
            if (_trackingStatusFilter != 'all' ||
                _trackingEquipmentFilter != 'all')
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Spacer(),
            Transform.rotate(
              angle: _showTrackingFilters ? 1.57 : 0,
              child: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _trackingStatusFilter = 'all';
                    _trackingEquipmentFilter = 'all';
                  });
                },
                child: const Text('Reset All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Status',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _trackingStatusFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Status')),
              DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
              DropdownMenuItem(value: 'due-soon', child: Text('Due Soon')),
              DropdownMenuItem(value: 'active', child: Text('Active')),
            ],
            onChanged: (value) =>
                setState(() => _trackingStatusFilter = value!),
          ),
          const SizedBox(height: 16),
          const Text(
            'Equipment Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _trackingEquipmentFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Equipment')),
              DropdownMenuItem(value: 'wheelchair', child: Text('Wheelchair')),
              DropdownMenuItem(value: 'walker', child: Text('Walker')),
              DropdownMenuItem(value: 'crutches', child: Text('Crutches')),
              DropdownMenuItem(
                value: 'hospital bed',
                child: Text('Hospital Bed'),
              ),
              DropdownMenuItem(
                value: 'oxygen machines',
                child: Text('Oxygen Machines'),
              ),
              DropdownMenuItem(value: 'others', child: Text('Others')),
            ],
            onChanged: (value) =>
                setState(() => _trackingEquipmentFilter = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStats(List<ActiveRental> filteredRentals) {
    int overdueCount = filteredRentals
        .where((r) => r.status == 'overdue')
        .length;
    int dueSoonCount = filteredRentals
        .where((r) => r.status == 'due-soon')
        .length;
    int activeCount = filteredRentals.where((r) => r.status == 'active').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Showing ${filteredRentals.length} of ${_activeRentals.length} rentals',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  'Overdue',
                  overdueCount.toString(),
                  Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  'Due Soon',
                  dueSoonCount.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  'Active',
                  activeCount.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'overdue':
        return Colors.red;
      case 'due-soon':
        return Colors.orange;
      case 'active':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'overdue':
        return 'Overdue';
      case 'due-soon':
        return 'Due Soon';
      case 'active':
        return 'Active';
      default:
        return 'Unknown';
    }
  }

  Color _getTimeRemainingColor(int days) {
    if (days < 0) return Colors.red[600]!;
    if (days <= 2) return Colors.orange[600]!;
    return Colors.green[600]!;
  }

  Widget _buildNotificationsTab() {
    // Apply filters
    List<AppNotification> filteredNotifications = _visibleNotifications.where((
      notification,
    ) {
      if (_notificationTypeFilter != 'all' &&
          notification.type != _notificationTypeFilter) {
        return false;
      }
      if (_notificationPriorityFilter != 'all' &&
          notification.priority != _notificationPriorityFilter) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        _buildNotificationFilterButton(),
        if (_showNotificationFilters) ...[
          const SizedBox(height: 16),
          _buildNotificationFilters(),
        ],
        const SizedBox(height: 16),
        if (filteredNotifications.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No Notifications Found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        else
          ...filteredNotifications.map((notification) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () =>
                      setState(() => _selectedNotification = notification),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getPriorityIcon(notification.priority),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                            notification.priority,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          notification.priority,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _getPriorityColor(
                                              notification.priority,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notification.message,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        notification.user,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Text(
                                        notification.time,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => setState(
                                  () => _selectedNotification = notification,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'View',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _dismissedNotifications.add(notification.id);
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Dismiss',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildNotificationFilterButton() {
    return InkWell(
      onTap: () =>
          setState(() => _showNotificationFilters = !_showNotificationFilters),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color:
                  (_notificationTypeFilter != 'all' ||
                      _notificationPriorityFilter != 'all')
                  ? Colors.indigo
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Filters',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color:
                    (_notificationTypeFilter != 'all' ||
                        _notificationPriorityFilter != 'all')
                    ? Colors.indigo
                    : Colors.black,
              ),
            ),
            if (_notificationTypeFilter != 'all' ||
                _notificationPriorityFilter != 'all')
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Spacer(),
            Transform.rotate(
              angle: _showNotificationFilters ? 1.57 : 0,
              child: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _notificationTypeFilter = 'all';
                    _notificationPriorityFilter = 'all';
                  });
                },
                child: const Text('Reset All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Notification Type',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _notificationTypeFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Types')),
              DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
              DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
              DropdownMenuItem(value: 'donation', child: Text('Donation')),
              DropdownMenuItem(
                value: 'maintenance',
                child: Text('Maintenance'),
              ),
              DropdownMenuItem(value: 'returned', child: Text('Returned')),
            ],
            onChanged: (value) =>
                setState(() => _notificationTypeFilter = value!),
          ),
          const SizedBox(height: 16),
          const Text(
            'Priority Level',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _notificationPriorityFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Priorities')),
              DropdownMenuItem(value: 'high', child: Text('High Priority')),
              DropdownMenuItem(value: 'medium', child: Text('Medium Priority')),
              DropdownMenuItem(value: 'low', child: Text('Low Priority')),
            ],
            onChanged: (value) =>
                setState(() => _notificationPriorityFilter = value!),
          ),
        ],
      ),
    );
  }

  Widget _getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icon(Icons.warning, color: Colors.red[500], size: 20);
      case 'medium':
        return Icon(Icons.access_time, color: Colors.orange[500], size: 20);
      case 'low':
        return Icon(Icons.check_circle, color: Colors.green[500], size: 20);
      default:
        return Icon(Icons.notifications, color: Colors.grey[500], size: 20);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBottomNav() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.trending_up, 'Reports'),
                _buildNavItem(1, Icons.access_time, 'Tracking'),
                _buildNavItem(
                  2,
                  Icons.notifications,
                  'Alerts',
                  badge: _highPriorityCount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {int? badge}) {
    final isActive = _activeTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.indigo[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isActive ? Colors.indigo[600] : Colors.grey[500],
                    size: 24,
                  ),
                  if (badge != null && badge > 0)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.indigo[600] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationModal() {
    final notification = _selectedNotification!;
    return GestureDetector(
      onTap: () => setState(() => _selectedNotification = null),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo[600]!, Colors.indigo[700]!],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              setState(() => _selectedNotification = null),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Priority Badge
                          Row(
                            children: [
                              _getPriorityIcon(notification.priority),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(
                                    notification.priority,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${notification.priority.toUpperCase()} PRIORITY',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getPriorityColor(
                                      notification.priority,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Title and Message
                          Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // User Information
                          if (notification.phone != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.indigo[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Customer Information',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow('Name', notification.user),
                                  if (notification.phone != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Phone',
                                      notification.phone!,
                                    ),
                                  ],
                                  if (notification.email != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Email',
                                      notification.email!,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                          // Equipment Information
                          if (notification.checkoutDate != null ||
                              notification.equipmentType != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.inventory_2,
                                        color: Colors.indigo[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        notification.type == 'donation'
                                            ? 'Donation Information'
                                            : 'Rental Information',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (notification.equipmentType != null)
                                    _buildDetailRow(
                                      'Equipment Type',
                                      notification.equipmentType!,
                                    ),
                                  if (notification.condition != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Condition',
                                      notification.condition!,
                                    ),
                                  ],
                                  if (notification.checkoutDate != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Checkout Date',
                                      notification.checkoutDate!,
                                    ),
                                  ],
                                  if (notification.dueDate != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Due Date',
                                      notification.dueDate!,
                                    ),
                                  ],
                                  if (notification.returnDate != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Return Date',
                                      notification.returnDate!,
                                    ),
                                  ],
                                  if (notification.lastMaintenance != null) ...[
                                    const SizedBox(height: 12),
                                    _buildDetailRow(
                                      'Last Maintenance',
                                      notification.lastMaintenance!,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          // Action Buttons
                          ..._buildActionButtons(notification),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons(AppNotification notification) {
    List<Widget> buttons = [];

    // Donation Button
    buttons.add(
      _buildActionButton(
        'Donations',
        Colors.green[600]!,
        Icons.volunteer_activism,
        () {
          // Navigate to AdminPendingDonations page
          // Uncomment when you have the AdminPendingDonations widget
          // Navigator.push(
          //   context,
          //   slideUpRoute(const AdminPendingDonations()),
          // );

          // For now, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Navigating to Pending Donations...'),
              duration: Duration(seconds: 2),
            ),
          );
          setState(() => _selectedNotification = null);
        },
      ),
    );

    buttons.add(const SizedBox(height: 12));

    // Reminder Button
    buttons.add(
      _buildActionButton(
        'Send Reminder',
        Colors.indigo[600]!,
        Icons.email_outlined,
        () {
          // Send email notification
          if (notification.email != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email reminder sent to ${notification.email}'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No email address available'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }
          setState(() => _selectedNotification = null);
        },
      ),
    );

    return buttons;
  }

  Widget _buildActionButton(
    String text,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// Slide up route animation (add this helper function)
Route slideUpRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

// Data Models
class RentalData {
  final String name;
  final int rented;
  final int donated;

  RentalData(this.name, this.rented, this.donated);
}

class TrendData {
  final String month;
  final int rentals;
  final int maintenance;
  final int overdue;

  TrendData(this.month, this.rentals, this.maintenance, this.overdue);
}

class StatusData {
  final String name;
  final int value;
  final Color color;

  StatusData(this.name, this.value, this.color);
}

class ActiveRental {
  final String equipment;
  final String user;
  final String checkoutDate;
  final String dueDate;
  final String status;
  final int daysRemaining;

  ActiveRental({
    required this.equipment,
    required this.user,
    required this.checkoutDate,
    required this.dueDate,
    required this.status,
    required this.daysRemaining,
  });
}

class AppNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final String user;
  final String? phone;
  final String? email;
  final String? checkoutDate;
  final String? dueDate;
  final String? returnDate;
  final String? equipmentType;
  final String? condition;
  final String? lastMaintenance;
  final String? nextMaintenance;
  final String? maintenanceType;
  final String time;
  final String priority;
  final String details;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.user,
    this.phone,
    this.email,
    this.checkoutDate,
    this.dueDate,
    this.returnDate,
    this.equipmentType,
    this.condition,
    this.lastMaintenance,
    this.nextMaintenance,
    this.maintenanceType,
    required this.time,
    required this.priority,
    required this.details,
  });
}

class RentalHistoryPage extends StatefulWidget {
  const RentalHistoryPage({Key? key}) : super(key: key);

  @override
  State<RentalHistoryPage> createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends State<RentalHistoryPage> {
  String _viewMode = 'all'; // 'all', 'active', 'completed'
  String _searchQuery = '';

  // Sample data - replace with actual data from your backend
  final List<RentalHistory> _allRentals = [
    // Active Rentals
    RentalHistory(
      id: 1,
      equipment: 'Wheelchair',
      user: 'Ahmed Al-Khalifa',
      phone: '+973 3333 1234',
      email: 'ahmed.alkhalifa@email.com',
      checkoutDate: '2024-11-25',
      dueDate: '2024-12-03',
      returnDate: null,
      status: 'overdue',
      notes: 'Customer contacted twice',
    ),
    RentalHistory(
      id: 2,
      equipment: 'Walker',
      user: 'Fatima Mohammed',
      phone: '+973 3333 5678',
      email: 'fatima.m@email.com',
      checkoutDate: '2024-11-28',
      dueDate: '2024-12-06',
      returnDate: null,
      status: 'active',
      notes: 'Reminder sent',
    ),
    RentalHistory(
      id: 3,
      equipment: 'Hospital Bed',
      user: 'Mohammed Ali',
      phone: '+973 3333 7890',
      email: 'mohammed.ali@email.com',
      checkoutDate: '2024-11-20',
      dueDate: '2024-12-20',
      returnDate: null,
      status: 'active',
      notes: 'Extension requested',
    ),
    // Completed Rentals
    RentalHistory(
      id: 4,
      equipment: 'Crutches',
      user: 'Ali Hassan',
      phone: '+973 3333 9999',
      email: 'ali.hassan@email.com',
      checkoutDate: '2024-11-15',
      dueDate: '2024-12-03',
      returnDate: '2024-12-03',
      status: 'completed',
      notes: 'Returned on time, excellent condition',
    ),
    RentalHistory(
      id: 5,
      equipment: 'Wheelchair',
      user: 'Sara Ahmed',
      phone: '+973 3333 4567',
      email: 'sara.ahmed@email.com',
      checkoutDate: '2024-10-20',
      dueDate: '2024-11-20',
      returnDate: '2024-11-18',
      status: 'completed',
      notes: 'Returned early',
    ),
    RentalHistory(
      id: 6,
      equipment: 'Oxygen Machine',
      user: 'Khalid Ibrahim',
      phone: '+973 3333 2468',
      email: 'khalid.i@email.com',
      checkoutDate: '2024-10-01',
      dueDate: '2024-11-01',
      returnDate: '2024-11-05',
      status: 'completed',
      notes: 'Returned late, late fee applied',
    ),
  ];

  List<RentalHistory> get _filteredRentals {
    List<RentalHistory> filtered = _allRentals;

    // Filter by view mode
    if (_viewMode == 'active') {
      filtered = filtered.where((r) => r.status != 'completed').toList();
    } else if (_viewMode == 'completed') {
      filtered = filtered.where((r) => r.status == 'completed').toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((r) {
        return r.user.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.equipment.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.phone.contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildViewModeSelector(),
                  const SizedBox(height: 16),
                  _buildStats(),
                  const SizedBox(height: 16),
                  ..._filteredRentals
                      .map((rental) => _buildRentalCard(rental))
                      .toList(),
                  if (_filteredRentals.isEmpty) _buildEmptyState(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[600]!, Colors.indigo[700]!],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rental History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View all rentals and history',
                      style: TextStyle(color: Color(0xFFc7d2fe), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by name, equipment, or phone...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildViewModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildViewModeButton('all', 'All Rentals')),
          Expanded(child: _buildViewModeButton('active', 'Active')),
          Expanded(child: _buildViewModeButton('completed', 'Completed')),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(String mode, String label) {
    final isActive = _viewMode == mode;
    return InkWell(
      onTap: () => setState(() => _viewMode = mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    int activeCount = _allRentals.where((r) => r.status != 'completed').length;
    int completedCount = _allRentals
        .where((r) => r.status == 'completed')
        .length;
    int overdueCount = _allRentals.where((r) => r.status == 'overdue').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Active',
              activeCount.toString(),
              Colors.blue,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem(
              'Completed',
              completedCount.toString(),
              Colors.green,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem(
              'Overdue',
              overdueCount.toString(),
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildRentalCard(RentalHistory rental) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(rental.status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.equipment,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rental.user,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(rental.status).withOpacity(0.1),
                  border: Border.all(color: _getStatusColor(rental.status)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(rental.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(rental.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone, rental.phone),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email, rental.email),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Checkout:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      rental.checkoutDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Due Date:',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      rental.dueDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (rental.returnDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Returned:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        rental.returnDate!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (rental.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rental.notes,
                      style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Rentals Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'overdue':
        return Colors.red;
      case 'active':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'overdue':
        return 'Overdue';
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}

// Data Model for Rental History
class RentalHistory {
  final int id;
  final String equipment;
  final String user;
  final String phone;
  final String email;
  final String checkoutDate;
  final String dueDate;
  final String? returnDate;
  final String status; // 'active', 'overdue', 'completed'
  final String notes;

  RentalHistory({
    required this.id,
    required this.equipment,
    required this.user,
    required this.phone,
    required this.email,
    required this.checkoutDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    required this.notes,
  });
}
