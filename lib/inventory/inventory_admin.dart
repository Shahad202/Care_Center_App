import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project444/profilePage.dart';
import 'package:project444/login.dart';
import 'package:project444/inventory/add_item.dart';

class NewinventoryWidget extends StatefulWidget {
  @override
  _NewinventoryWidgetState createState() => _NewinventoryWidgetState();
}

class _NewinventoryWidgetState extends State<NewinventoryWidget> {
  late TextEditingController _searchController;
  String _filterStatus = 'All';
  List<Map<String, String>> _filteredItems = [];
  String _userRole = 'user';

  // Filter state variables
  List<String> _selectedItemTypes = [];
  List<String> _selectedAvailabilityStatus = [];
  List<String> _selectedConditions = [];
  String _selectedLocation = 'All Locations';

  final List<String> _itemTypes = [
    'Mobility Aid',
    'Medical Device',
    'Furniture',
    'Equipment',
  ];

  final List<String> _availabilityStatuses = [
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  final List<String> _conditions = ['Excellent', 'Good', 'Fair', 'Poor'];

  final List<String> _locations = [
    'All Locations',
    'Ward A',
    'Ward B',
    'Clinic',
    'Storage Room A',
  ];

  final List<Map<String, String>> _inventoryItems = [
    {
      'name': 'Wheelchair',
      'category': 'Mobility Aid',
      'status': 'Available',
      'location': 'Ward A - Room 101',
      'quantity': '5',
    },
    {
      'name': 'Walker',
      'category': 'Mobility Aid',
      'status': 'Rented',
      'location': 'Ward B - Room 205',
      'quantity': '3',
    },
    {
      'name': 'Blood Pressure Monitor',
      'category': 'Medical Device',
      'status': 'Available',
      'location': 'Clinic Room 3',
      'quantity': '8',
    },
    {
      'name': 'Hospital Bed',
      'category': 'Furniture',
      'status': 'Maintenance',
      'location': 'Storage Room A',
      'quantity': '2',
    },
    {
      'name': 'Thermometer',
      'category': 'Medical Device',
      'status': 'Available',
      'location': 'Clinic Room 1',
      'quantity': '15',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterItems);
    _filteredItems = _inventoryItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _inventoryItems.where((item) {
        final matchesSearch =
            item['name']!.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            item['category']!.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
        final matchesStatus =
            _filterStatus == 'All' || item['status'] == _filterStatus;
        final matchesItemType =
            _selectedItemTypes.isEmpty ||
            _selectedItemTypes.contains(item['category']);
        final matchesAvailability =
            _selectedAvailabilityStatus.isEmpty ||
            _selectedAvailabilityStatus.contains(item['status']);
        final matchesLocation =
            _selectedLocation == 'All Locations' ||
            item['location']!.contains(_selectedLocation);
        return matchesSearch &&
            matchesStatus &&
            matchesItemType &&
            matchesAvailability &&
            matchesLocation;
      }).toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color.fromRGBO(0, 201, 80, 1);
      case 'Rented':
        return const Color.fromRGBO(255, 105, 0, 1);
      case 'Maintenance':
        return const Color.fromRGBO(106, 114, 130, 1);
      default:
        return const Color.fromRGBO(106, 114, 130, 1);
    }
  }

  void _showFilterDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, size: 24),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ITEM TYPE
                      const Text(
                        'Item Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _itemTypes.map((type) {
                          final isSelected = _selectedItemTypes.contains(type);
                          return FilterChip(
                            label: Text(type),
                            selected: isSelected,
                            selectedColor: const Color(0xFF155DFC),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedItemTypes.add(type);
                                } else {
                                  _selectedItemTypes.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // AVAILABILITY
                      const Text(
                        'Availability Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availabilityStatuses.map((status) {
                          final isSelected = _selectedAvailabilityStatus
                              .contains(status);

                          return FilterChip(
                            label: Text(status),
                            selected: isSelected,
                            selectedColor: const Color(0xFF155DFC),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedAvailabilityStatus.add(status);
                                } else {
                                  _selectedAvailabilityStatus.remove(status);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // CONDITION
                      const Text(
                        'Condition',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _conditions.map((condition) {
                          final isSelected = _selectedConditions.contains(
                            condition,
                          );

                          return FilterChip(
                            label: Text(condition),
                            selected: isSelected,
                            selectedColor: const Color(0xFF155DFC),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedConditions.add(condition);
                                } else {
                                  _selectedConditions.remove(condition);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // LOCATION
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),

                      DropdownButton<String>(
                        value: _selectedLocation,
                        isExpanded: true,
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedLocation = value ?? 'All Locations';
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // BUTTONS
                      Row(
                        children: [
                          // RESET
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setDialogState(() {
                                  _selectedItemTypes.clear();
                                  _selectedAvailabilityStatus.clear();
                                  _selectedConditions.clear();
                                  _selectedLocation = 'All Locations';
                                });
                              },
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // APPLY
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _filterItems();
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF155DFC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Apply Filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 251, 1),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF003465)),
              child: FirebaseAuth.instance.currentUser == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {},
                          child: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 40,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome, Guest!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        String name = (data["name"] ?? "User").toString();
                        String? imageUrl = data["profileImage"] as String?;
                        _userRole = (data['role'] ?? 'user').toString();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: imageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Welcome, $name!",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                final role = _userRole.toLowerCase();
                if (role == 'admin') {
                  Navigator.pushReplacementNamed(context, '/admin');
                } else {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text(
                'Inventory Management',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewinventoryWidget()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text(
                'Reservation & Rental',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inventory');
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donations', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/donor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'Tracking & Reports',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
        icon: const Icon(Icons.add, size: 24, color: Colors.white),
        label: const Text(
          'Add Item',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Header with gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(21, 93, 252, 1),
                        Color.fromRGBO(13, 71, 230, 1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Inventory Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arimo',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_filteredItems.length} items',
                            style: const TextStyle(
                              color: Color.fromRGBO(219, 234, 254, 1),
                              fontFamily: 'Arimo',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search & Filter Bar
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search Field with Filter Buttons
                      Row(
                        children: [
                          // Search Field
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search inventory...',
                                hintStyle: const TextStyle(
                                  color: Color.fromRGBO(156, 163, 175, 1),
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color.fromRGBO(156, 163, 175, 1),
                                  size: 18,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          _filterItems();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(
                                            156,
                                            163,
                                            175,
                                            1,
                                          ),
                                          size: 18,
                                        ),
                                      )
                                    : null,
                                filled: true,
                                fillColor: const Color.fromRGBO(
                                  249,
                                  250,
                                  251,
                                  1,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(208, 213, 219, 1),
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(208, 213, 219, 1),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(21, 93, 252, 1),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (value) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Filter Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color.fromRGBO(208, 213, 219, 1),
                                width: 1.2,
                              ),
                              color: const Color.fromRGBO(249, 250, 251, 1),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.filter_list,
                                color: Color.fromRGBO(73, 85, 101, 1),
                                size: 20,
                              ),
                              onPressed: () => _showFilterDialog(context),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Sort Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color.fromRGBO(208, 213, 219, 1),
                                width: 1.2,
                              ),
                              color: const Color.fromRGBO(249, 250, 251, 1),
                            ),
                            child: const IconButton(
                              icon: Icon(
                                Icons.swap_vert,
                                color: Color.fromRGBO(73, 85, 101, 1),
                                size: 20,
                              ),
                              onPressed: null,
                              padding: EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Inventory Cards List
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: _filteredItems.isEmpty
                      ? _buildEmptyState()
                      : Column(
                          children: List.generate(_filteredItems.length, (
                            index,
                          ) {
                            final item = _filteredItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildInventoryCard(
                                context: context,
                                name: item['name']!,
                                category: item['category']!,
                                status: item['status']!,
                                statusColor: _getStatusColor(item['status']!),
                                location: item['location']!,
                                quantity: item['quantity']!,
                              ),
                            );
                          }),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildFilterChip(
  String label,
  bool isSelected,
  Function(bool) onSelected,
) {
  return FilterChip(
    label: Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.white : const Color.fromRGBO(73, 85, 101, 1),
        fontFamily: 'Arimo',
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    ),
    onSelected: onSelected,
    selected: isSelected,
    backgroundColor: const Color.fromRGBO(242, 244, 246, 1),
    selectedColor: const Color.fromRGBO(21, 93, 252, 1),
    side: BorderSide(
      color: isSelected
          ? const Color.fromRGBO(21, 93, 252, 1)
          : Colors.transparent,
      width: 0,
    ),
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromRGBO(242, 244, 246, 1),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 40,
              color: Color.fromRGBO(156, 163, 175, 1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No items found',
            style: TextStyle(
              color: Color.fromRGBO(31, 41, 55, 1),
              fontFamily: 'Arimo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Color.fromRGBO(156, 163, 175, 1),
              fontFamily: 'Arimo',
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
  );
}

void _showAddItemDialog(BuildContext ctx) {
  Navigator.push(
    ctx,
    MaterialPageRoute(builder: (context) => const AddItemScreen()),
  );
}

Widget _buildInventoryCard({
  required BuildContext context,
  required String name,
  required String category,
  required String status,
  required Color statusColor,
  required String location,
  required String quantity,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _showItemDetailsDialog(
        context,
        name,
        category,
        status,
        location,
        quantity,
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.08),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section with Status Badge
              Container(
                width: double.infinity,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(243, 244, 246, 1),
                  image: DecorationImage(
                    image: AssetImage('assets/images/Imagewithfallback.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Arimo',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Category
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color.fromRGBO(31, 41, 55, 1),
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category,
                      style: const TextStyle(
                        color: Color.fromRGBO(107, 114, 128, 1),
                        fontFamily: 'Arimo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Condition Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(242, 244, 246, 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Good',
                        style: TextStyle(
                          color: Color.fromRGBO(73, 85, 101, 1),
                          fontFamily: 'Arimo',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color.fromRGBO(107, 114, 128, 1),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                              fontFamily: 'Arimo',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Quantity
                    Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          color: Color.fromRGBO(107, 114, 128, 1),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Qty: $quantity',
                          style: const TextStyle(
                            color: Color.fromRGBO(107, 114, 128, 1),
                            fontFamily: 'Arimo',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showItemDetailsDialog(
  BuildContext ctx,
  String name,
  String category,
  String status,
  String location,
  String quantity,
) {
  showDialog(
    context: ctx,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Item Details',
                      style: TextStyle(
                        color: Color.fromRGBO(31, 41, 55, 1),
                        fontFamily: 'Arimo',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Name', name),
                _buildDetailRow('Category', category),
                _buildDetailRow('Status', status),
                _buildDetailRow('Location', location),
                _buildDetailRow('Quantity', quantity),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Color.fromRGBO(156, 163, 175, 1),
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(107, 114, 128, 1),
            fontFamily: 'Arimo',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
