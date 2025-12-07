import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InventoryUserWidget extends StatefulWidget {
  @override
  _InventoryUserWidgetState createState() => _InventoryUserWidgetState();
}

class _InventoryUserWidgetState extends State<InventoryUserWidget> {
  late TextEditingController _searchController;
  String _filterStatus = 'Available';
  String _selectedCategory = 'All';
  String _sourceFilter = 'All';
  String _viewMode = 'grid'; // 'grid' or 'list'

  final List<String> _statusFilters = ['All', 'Available', 'Rented', 'Maintenance', 'Donated'];
  final List<String> _categoryFilters = ['All', 'Mobility Aid', 'Medical Device', 'Furniture', 'Other'];
  final List<String> _sourceFilters = ['All', 'Donated', 'Rentable'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF10B981);
      case 'rented':
        return const Color(0xFFF59E0B);
      case 'donated':
        return const Color(0xFF3B82F6);
      case 'maintenance':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF003465),
        title: const Text(
          'Available Equipment',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == 'grid' ? 'list' : 'grid';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search equipment...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _statusFilters.map(_buildStatusChip).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categoryFilters.map(_buildCategoryChip).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    children: _sourceFilters.map(_buildSourceChip).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Items List
          Flexible(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('inventory')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: 300,
                      child: _buildEmptyState(),
                    );
                  }

                  // Filter items
                  final searchQuery = _searchController.text.toLowerCase();
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final category = (data['type'] ?? data['category'] ?? '').toString();
                    final status = (data['status'] ?? 'available').toString().toLowerCase();
                    final source = (data['source'] ?? 'manual').toString().toLowerCase();
                    final itemId = (data['itemId'] ?? '').toString().toLowerCase();
                    final tags = (data['tags'] as List?)?.join(' ').toLowerCase() ?? '';

                    final matchesSearch = searchQuery.isEmpty ||
                        name.contains(searchQuery) ||
                        category.toLowerCase().contains(searchQuery) ||
                        itemId.contains(searchQuery) ||
                        tags.contains(searchQuery);

                    final matchesStatus = _filterStatus == 'All' ||
                        status == _filterStatus.toLowerCase();

                    final matchesCategory = _selectedCategory == 'All' ||
                        category.toLowerCase() == _selectedCategory.toLowerCase();

                    bool matchesSource = true;
                    if (_sourceFilter == 'Donated') {
                      matchesSource = source == 'donation' || status == 'donated';
                    } else if (_sourceFilter == 'Rentable') {
                      matchesSource = source != 'donation' && status != 'donated';
                    }

                    return matchesSearch && matchesStatus && matchesCategory && matchesSource;
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return SizedBox(
                      height: 300,
                      child: _buildEmptyState(),
                    );
                  }

                  return _viewMode == 'grid'
                      ? _buildGridView(filteredDocs)
                      : _buildListView(filteredDocs);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<QueryDocumentSnapshot> docs) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;
          return _buildGridCard(data);
        },
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> docs) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;
          return _buildListCard(data);
        },
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    final isSelected = _filterStatus == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _filterStatus = label);
      },
      backgroundColor: const Color(0xFFF3F4F6),
      selectedColor: const Color(0xFF003465),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF374151),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      side: BorderSide.none,
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedCategory = label);
      },
      backgroundColor: const Color(0xFFF3F4F6),
      selectedColor: const Color(0xFF003465),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF374151),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      side: BorderSide.none,
    );
  }

  Widget _buildSourceChip(String label) {
    final isSelected = _sourceFilter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _sourceFilter = label);
      },
      selectedColor: const Color(0xFF003465),
      backgroundColor: const Color(0xFFF3F4F6),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF374151),
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildGridCard(Map<String, dynamic> data) {
    final rentalPrice = data['rentalPricePerDay'];
    final status = data['status'] ?? 'available';
    final statusColor = _getStatusColor(status);
    final category = data['type'] ?? data['category'] ?? 'Other';
    final source = (data['source'] ?? 'manual').toString();
    final location = data['location'] ?? '';
    final itemId = data['itemId'];

    String _statusLabel(String value) {
      final lower = value.toString().toLowerCase();
      if (lower == 'maintenance') return 'Maintenance';
      return lower[0].toUpperCase() + lower.substring(1);
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showItemDetails(data),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF003465).withOpacity(0.1),
                    const Color(0xFF1874CF).withOpacity(0.1),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getIconFromCategory(category),
                  size: 48,
                  color: const Color(0xFF003465),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _statusLabel(status),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: source == 'donation'
                              ? const Color(0xFFE0E7FF)
                              : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          source == 'donation' ? 'Donated' : 'Rentable',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: source == 'donation'
                                ? const Color(0xFF1D4ED8)
                                : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF6B7280)),
                      const SizedBox(width: 6),
                      Text(
                        'Qty: ${data['quantity'] ?? 0}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                      ),
                    ],
                  ),
                  if (rentalPrice != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'SR $rentalPrice/day',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF003465),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(Map<String, dynamic> data) {
    final rentalPrice = data['rentalPricePerDay'];
    final status = data['status'] ?? 'available';
    final statusColor = _getStatusColor(status);
    final category = data['type'] ?? data['category'] ?? 'Other';
    final source = (data['source'] ?? 'manual').toString();
    final location = data['location'] ?? '';
    final itemId = data['itemId'];

    String _statusLabel(String value) {
      final lower = value.toString().toLowerCase();
      if (lower == 'maintenance') return 'Maintenance';
      return lower[0].toUpperCase() + lower.substring(1);
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showItemDetails(data),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF003465).withOpacity(0.1),
                      const Color(0xFF1874CF).withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  _getIconFromCategory(category),
                  size: 40,
                  color: const Color(0xFF003465),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _statusLabel(status),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: source == 'donation'
                                ? const Color(0xFFE0E7FF)
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            source == 'donation' ? 'Donated' : 'Rentable',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: source == 'donation'
                                  ? const Color(0xFF1D4ED8)
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        Text(
                          'Qty: ${data['quantity'] ?? 0}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                        ),
                        if (itemId != null && itemId.toString().isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.tag, size: 14, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 2),
                          Text(
                            itemId.toString(),
                            style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        location,
                        style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (rentalPrice != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'SR $rentalPrice/day',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF003465),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'No equipment available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for new items',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconFromCategory(String category) {
    switch (category) {
      case 'Mobility Aid':
        return Icons.accessible;
      case 'Medical Device':
        return Icons.medical_services;
      case 'Furniture':
        return Icons.bed;
      default:
        return Icons.category;
    }
  }

  void _showItemDetails(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  data['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['category'] ?? 'Other',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                _detailRow('Item ID', (data['itemId'] ?? 'N/A').toString()),
                _detailRow('Type', data['type'] ?? data['category'] ?? 'N/A'),
                _detailRow('Source', (data['source'] ?? 'manual') == 'donation' ? 'Donated' : 'Rentable'),
                if ((data['description'] ?? '').toString().isNotEmpty)
                  _detailRow('Description', data['description']),
                _detailRow('Condition', data['condition'] ?? 'N/A'),
                _detailRow('Quantity', data['quantity']?.toString() ?? '0'),
                _detailRow('Location', data['location'] ?? 'N/A'),
                if (data['rentalPricePerDay'] != null)
                  _detailRow('Price', 'SR ${data['rentalPricePerDay']}/day'),
                if (data['images'] != null && (data['images'] as List).isNotEmpty)
                  _detailRow('Images', (data['images'] as List).join(', ')),
                if (data['tags'] != null && (data['tags'] as List).isNotEmpty)
                  _detailRow('Tags', (data['tags'] as List).join(', ')),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/renter');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003465),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reserve Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
