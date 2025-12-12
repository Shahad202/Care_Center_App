import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project444/profilePage.dart';
import 'package:project444/login.dart';
import 'package:project444/inventory/add_item.dart';
import 'package:project444/inventory/item_detail.dart';
import 'package:project444/inventory/edit_item.dart';

class NewinventoryWidget extends StatefulWidget {
  @override
  _NewinventoryWidgetState createState() => _NewinventoryWidgetState();
}

class _NewinventoryWidgetState extends State<NewinventoryWidget> {
  late TextEditingController _searchController;
  String _filterStatus = 'All';
  String _selectedCategory = 'All';
  String _sourceFilter = 'All';
  String _viewMode = 'grid'; // 'grid' or 'list'
  String _userRole = 'guest';

  final Map<String, IconData> itemIcons = {
    'wheelchair': Icons.wheelchair_pickup,
    'walker': Icons.accessibility_new,
    'crutches': Icons.elderly,
    'oxygen machine': Icons.medical_services,
    'hospital bed': Icons.bed,
    'other': Icons.inventory_2,
  };

  // Filter state variables
  List<String> _selectedItemTypes = [];
  List<String> _selectedCategories = [];
  List<String> _selectedAvailabilityStatus = [];
  List<String> _selectedConditions = [];
  String _selectedLocation = 'All Locations';

  // Sort state variables
  String _sortBy = 'Default Order';
  bool _sortAscending = true;

  // View toggle state
  bool _isGridView = false; // false = List view, true = Grid view

  List<Map<String, dynamic>> _filteredItems = [];

  final List<String> _itemTypes = [
    'wheelchair',
    'walker',
    'crutches',
    'oxygen machine',
    'hospital bed',
    'other',
  ];
  final List<String> _categories = [
    'Mobility Aid',
    'Medical Device',
    'Furniture',
    'Other',
  ];
  final List<String> _availabilityStatuses = [
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  final List<String> _conditions = [
    'New',
    'Like new',
    'Good',
    'Fair',
    'Needs Repair',
  ];

  final List<String> _locations = [
    'All Locations',
    'Ward A',
    'Ward B',
    'Clinic',
    'Storage Room A',
  ];

  final List<String> _sortOptions = [
    'Default Order',
    'Name (A → Z)',
    'Name (Z → A)',
    'Price (Low → High)',
    'Price (High → Low)',
    'Quantity (Low → High)',
    'Quantity (High → Low)',
  ];

  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Wheelchair',
      'type': 'wheelchair',
      'category': 'Mobility Aid',
      'status': 'Available',
      'location': 'Ward A - Room 101',
      'quantity': '5',
      'price': '6.000',
      'description':
          'Standard manual wheelchair with adjustable footrests and armrests. Suitable for indoor and outdoor use. Weight capacity up to 250 lbs.',
      'condition': 'New',
      'tags': ['Mobility', 'Medical Equipment', 'Daily Use'],
    },
    {
      'name': 'Walker',
      'type': 'walker',
      'category': 'Mobility Aid',
      'status': 'Rented',
      'location': 'Ward B - Room 205',
      'quantity': '3',
      'price': '4.500',
      'description':
          'Lightweight aluminum walker with rubber grips. Easy to fold and carry. Ideal for patients with limited mobility.',
      'condition': 'Good',
      'tags': ['Mobility', 'Lightweight', 'Portable'],
    },
    {
      'name': 'Blood Pressure Monitor',
      'type': 'other',
      'category': 'Medical Device',
      'status': 'Donated',
      'location': 'Clinic Room 3',
      'quantity': '8',
      'price': '3.000',
      'description':
          'Digital blood pressure monitor with automatic readings. Large LED display. Battery operated.',
      'condition': 'Like new',
      'tags': ['Medical', 'Monitoring', 'Digital'],
    },
    {
      'name': 'Hospital Bed',
      'type': 'hospital bed',
      'category': 'Furniture',
      'status': 'Maintenance',
      'location': 'Storage Room A',
      'quantity': '2',
      'price': '50.000',
      'description':
          'Adjustable electric hospital bed with side rails and mattress. Multiple position settings for patient comfort.',
      'condition': 'Fair',
      'tags': ['Hospital Equipment', 'Adjustable', 'Electric'],
    },
    {
      'name': 'Thermometer',
      'type': 'other',
      'category': 'Medical Device',
      'status': 'Available',
      'location': 'Clinic Room 1',
      'quantity': '15',
      'price': '2.000',
      'description':
          'Digital thermometer with fast reading capability. Water resistant design. Automatic shutdown.',
      'condition': 'New',
      'tags': ['Medical', 'Temperature', 'Portable'],
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
            _selectedItemTypes.contains(item['type']);
        final matchesCategory =
            _selectedCategories.isEmpty ||
            _selectedCategories.contains(item['category']);

        final matchesAvailability =
            _selectedAvailabilityStatus.isEmpty ||
            _selectedAvailabilityStatus.contains(item['status']);
        final matchesCondition =
            _selectedConditions.isEmpty ||
            _selectedConditions.contains(item['condition']);
        final matchesLocation =
            _selectedLocation == 'All Locations' ||
            item['location']!.contains(_selectedLocation);
        return matchesSearch &&
            matchesStatus &&
            matchesItemType &&
            matchesAvailability &&
            matchesLocation &&
            matchesCondition &&
            matchesCategory;
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
      case 'Donated':
        return const Color.fromRGBO(173, 59, 183, 1);
      default:
        return const Color.fromRGBO(170, 192, 235, 1);
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

                      const Text(
                        'Category',
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
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: const Color(0xFF155DFC),
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  _selectedCategories.add(cat);
                                } else {
                                  _selectedCategories.remove(cat);
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

  void _showSortDialog(BuildContext ctx) {
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
                            'Sort By',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(31, 41, 55, 1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, size: 24),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sort Options
                      ...List.generate(_sortOptions.length, (index) {
                        final option = _sortOptions[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setDialogState(() {
                                  _sortBy = option;
                                  _applySort();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: _sortBy == option
                                      ? const Color.fromRGBO(21, 93, 252, 0.1)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _sortBy == option
                                            ? const Color.fromRGBO(
                                                21,
                                                93,
                                                252,
                                                1,
                                              )
                                            : const Color.fromRGBO(
                                                73,
                                                85,
                                                101,
                                                1,
                                              ),
                                      ),
                                    ),
                                    if (_sortBy == option)
                                      const Icon(
                                        Icons.check,
                                        color: Color.fromRGBO(21, 93, 252, 1),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (index < _sortOptions.length - 1)
                              const Divider(height: 16),
                          ],
                        );
                      }),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromRGBO(107, 114, 128, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                21,
                                93,
                                252,
                                1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _applySort();
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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

  void _applySort() {
    setState(() {
      switch (_sortBy) {
        case 'Name (A → Z)':
          _filteredItems.sort(
            (a, b) =>
                a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()),
          );
          break;
        case 'Name (Z → A)':
          _filteredItems.sort(
            (a, b) =>
                b['name']!.toLowerCase().compareTo(a['name']!.toLowerCase()),
          );
          break;
        case 'Price (Low → High)':
          _filteredItems.sort(
            (a, b) => double.parse(
              a['price'] ?? '0',
            ).compareTo(double.parse(b['price'] ?? '0')),
          );
          break;

        case 'Price (High → Low)':
          _filteredItems.sort(
            (a, b) => double.parse(
              b['price'] ?? '0',
            ).compareTo(double.parse(a['price'] ?? '0')),
          );
          break;
        case 'Quantity (Low → High)':
          _filteredItems.sort(
            (a, b) =>
                int.parse(a['quantity']!).compareTo(int.parse(b['quantity']!)),
          );
          break;
        case 'Quantity (High → Low)':
          _filteredItems.sort(
            (a, b) =>
                int.parse(b['quantity']!).compareTo(int.parse(a['quantity']!)),
          );
          break;
        default:
          // Default Order - reset to original
          _filteredItems = List.from(_inventoryItems);
          break;
      }
    });
  }

  void _showItemDetailsDialog(
    BuildContext ctx,
    String name,
    String category,
    String status,
    String location,
    String quantity,
  ) {
    // Find the item in inventory to get all details
    final item = _inventoryItems.firstWhere(
      (item) => item['name'] == name,
      orElse: () => {
        'name': name,
        'category': category,
        'status': status,
        'location': location,
        'quantity': quantity,
        'price': '0.000',
        'description': 'No description available',
        'condition': 'Good',
        'tags': [],
      },
    );

    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
          name: item['name'] ?? name,
          category: item['category'] ?? category,
          status: item['status'] ?? status,
          location: item['location'] ?? location,
          quantity: item['quantity'] ?? quantity,
          description: item['description'] ?? 'No description available',
          condition: item['condition'] ?? 'Good',
          tags: List<String>.from(item['tags'] ?? []),
          rentalPrice: item['price'] ?? '0.000',
          isGuest: false,
          itemIcons: itemIcons,
          type: item['type'],
        ),
      ),
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
                            child: IconButton(
                              icon: const Icon(
                                Icons.swap_vert,
                                color: Color.fromRGBO(73, 85, 101, 1),
                                size: 20,
                              ),
                              onPressed: () => _showSortDialog(context),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // View Toggle Button
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
                              icon: Icon(
                                _isGridView ? Icons.view_list : Icons.grid_view,
                                color: const Color.fromRGBO(73, 85, 101, 1),
                                size: 20,
                              ),
                              onPressed: () => setState(() {
                                _isGridView = !_isGridView;
                              }),
                              padding: const EdgeInsets.all(8),
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
                      : _isGridView
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.60,
                              ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return _buildInventoryCard(
                              context: context,
                              name: item['name']!,

                              category: item['category']!,
                              status: item['status']!,
                              statusColor: _getStatusColor(item['status']!),
                              location: item['location']!,
                              quantity: item['quantity']!,
                              onTap: () => _showItemDetailsDialog(
                                context,
                                item['name']!,
                                item['category']!,
                                item['status']!,
                                item['location']!,
                                item['quantity']!,
                              ),
                              itemIcons: itemIcons,
                            );
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFF2F4F6),
                                  ),
                                  child: Icon(
                                    itemIcons[item['type']
                                            .toString()
                                            .toLowerCase()] ??
                                        Icons.inventory_2_outlined,
                                    size: 28,
                                    color: const Color.fromRGBO(
                                      100,
                                      116,
                                      139,
                                      1,
                                    ),
                                  ),
                                ),

                                title: Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['category']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          item['location']!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item['status']!),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    item['status']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                onTap: () => _showItemDetailsDialog(
                                  context,
                                  item['name']!,
                                  item['category']!,
                                  item['status']!,
                                  item['location']!,
                                  item['quantity']!,
                                ),
                              ),
                            );
                          },
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
  required VoidCallback onTap,
  required Map<String, IconData> itemIcons,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        itemIcons[name.toLowerCase()] ??
                            itemIcons[category.toLowerCase()] ??
                            Icons.inventory_2,
                        size: 70,
                        color: const Color.fromRGBO(100, 116, 139, 1),
                      ),
                    ),

                    // Status badge
                    Positioned(
                      right: 12,
                      top: 12,
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
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(107, 114, 128, 1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Qty: $quantity',
                          style: const TextStyle(
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
