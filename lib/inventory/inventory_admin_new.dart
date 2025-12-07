import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InventoryAdminWidget extends StatefulWidget {
  @override
  _InventoryAdminWidgetState createState() => _InventoryAdminWidgetState();
}

class _InventoryAdminWidgetState extends State<InventoryAdminWidget> {
  late TextEditingController _searchController;
  String _filterStatus = 'All';
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
        return const Color(0xFFEF4444);
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
          'Inventory Management',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(),
        backgroundColor: const Color(0xFF003465),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Item',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
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
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${snapshot.error}'),
                          ],
                        ),
                      ),
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

  Widget _buildGridView(List<QueryDocumentSnapshot> docs) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final doc = docs[index];
          final data = doc.data() as Map<String, dynamic>;
          return _buildGridCard(doc.id, data);
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
          final doc = docs[index];
          final data = doc.data() as Map<String, dynamic>;
          return _buildListCard(doc.id, data);
        },
      ),
    );
  }

  Widget _buildGridCard(String docId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'available';
    final statusColor = _getStatusColor(status);
    final category = data['type'] ?? data['category'] ?? 'Other';
    final source = (data['source'] ?? 'manual').toString();
    final rentalPrice = data['rentalPricePerDay'];
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
        onTap: () => _showItemDetails(docId, data),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [
                    statusColor.withOpacity(0.1),
                    statusColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  _getIconFromCategory(data['category'] ?? ''),
                  size: 40,
                  color: const Color(0xFF003465),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                          maxLines: 2,
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
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 4),
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
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF6B7280)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (rentalPrice != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'SR $rentalPrice/day',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF003465),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(String docId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'available';
    final statusColor = _getStatusColor(status);
    final category = data['type'] ?? data['category'] ?? 'Other';
    final source = (data['source'] ?? 'manual').toString();
    final rentalPrice = data['rentalPricePerDay'];
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
      child: ListTile(
        onTap: () => _showItemDetails(docId, data),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconFromCategory(data['category'] ?? ''),
            color: const Color(0xFF003465),
          ),
        ),
        title: Text(
          data['name'] ?? 'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$category • Qty: ${data['quantity'] ?? 0}',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            if (location.isNotEmpty)
              Text(
                location,
                style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            if (itemId != null && itemId.toString().isNotEmpty)
              Text(
                'ID: ${itemId.toString()}',
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
              ),
            if (rentalPrice != null)
              Text(
                'SR $rentalPrice/day',
                style: const TextStyle(
                  color: Color(0xFF003465),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusLabel(status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: source == 'donation'
                    ? const Color(0xFFE0E7FF)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                source == 'donation' ? 'Donated' : 'Rentable',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: source == 'donation'
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFF4B5563),
                ),
              ),
            ),
          ],
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
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
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

  void _showItemDetails(String docId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(data['status'] ?? 'available').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (data['status'] ?? 'available')[0].toUpperCase() + 
                            (data['status'] ?? 'available').substring(1),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(data['status'] ?? 'available'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _detailSection('Basic Information', [
                  _detailRow('Item ID', (data['itemId'] ?? docId).toString()),
                  _detailRow('Type', data['type'] ?? data['category'] ?? 'N/A'),
                  _detailRow('Category', data['category'] ?? 'N/A'),
                  _detailRow('Source', (data['source'] ?? 'manual') == 'donation' ? 'Donated' : 'Rentable'),
                  _detailRow('Condition', data['condition'] ?? 'N/A'),
                  _detailRow('Quantity', data['quantity']?.toString() ?? '0'),
                  _detailRow('Location', data['location'] ?? 'N/A'),
                ]),
                if (data['description'] != null && data['description'].isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _detailSection('Description', [
                    Text(
                      data['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                  ]),
                ],
                if (data['rentalPricePerDay'] != null) ...[
                  const SizedBox(height: 24),
                  _detailSection('Pricing', [
                    _detailRow('Rental Price', 'SR ${data['rentalPricePerDay']}/day'),
                  ]),
                ],
                if (data['images'] != null && (data['images'] as List).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _detailSection('Images', [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (data['images'] as List).map((img) {
                        final url = img.toString();
                        return Chip(
                          label: Text(url.length > 28 ? '${url.substring(0, 25)}...' : url),
                          backgroundColor: const Color(0xFFF3F4F6),
                        );
                      }).toList(),
                    ),
                  ]),
                ],
                if (data['tags'] != null && (data['tags'] as List).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _detailSection('Tags', [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (data['tags'] as List).map((tag) {
                        return Chip(
                          label: Text(tag.toString()),
                          backgroundColor: const Color(0xFFE0E7FF),
                          labelStyle: const TextStyle(
                            color: Color(0xFF003465),
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ]),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditDialog(docId, data);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFF003465)),
                          foregroundColor: const Color(0xFF003465),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmDelete(docId),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  void _showAddItemDialog() {
    final itemIdController = TextEditingController();
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    String selectedType = _categoryFilters.firstWhere(
      (c) => c != 'All',
      orElse: () => 'Mobility Aid',
    );
    categoryController.text = selectedType;
    final descriptionController = TextEditingController();
    final conditionController = TextEditingController();
    final quantityController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();
    final tagsController = TextEditingController();
    final imagesController = TextEditingController();
    String selectedStatus = 'available';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemIdController,
                decoration: const InputDecoration(
                  labelText: 'Item ID / Code *',
                  hintText: 'e.g., INV-001',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type *',
                  border: OutlineInputBorder(),
                ),
                items: _categoryFilters
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  selectedType = value ?? selectedType;
                  categoryController.text = selectedType;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: conditionController,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  hintText: 'New, Good, Fair, etc.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rental Price Per Day (SR)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'wheelchair, electric, outdoor',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imagesController,
                decoration: const InputDecoration(
                  labelText: 'Image URLs (comma separated)',
                  hintText: 'https://.../img1, https://.../img2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                ),
                items: ['available', 'rented', 'maintenance', 'donated']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status[0].toUpperCase() + status.substring(1)),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (itemIdController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  categoryController.text.isEmpty ||
                  quantityController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill required fields')),
                );
                return;
              }
              
              // Validate and ensure quantity is > 0
              final qty = int.tryParse(quantityController.text) ?? 0;
              if (qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quantity must be greater than 0')),
                );
                return;
              }

              try {
                final tags = tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final images = imagesController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

                final price = priceController.text.isNotEmpty
                  ? double.tryParse(priceController.text)
                  : null;

                final normalizedStatus = selectedStatus.toLowerCase();
                final source = normalizedStatus == 'donated' ? 'donation' : 'manual';

                await FirebaseFirestore.instance.collection('inventory').add({
                  'itemId': itemIdController.text.trim(),
                  'name': nameController.text,
                  'type': selectedType,
                  'category': categoryController.text.isNotEmpty ? categoryController.text : selectedType,
                  'description': descriptionController.text,
                  'condition': conditionController.text,
                  'quantity': qty,
                  'location': locationController.text,
                  'rentalPricePerDay': price,
                  'tags': tags,
                  'images': images,
                  'status': normalizedStatus,
                  'availabilityStatus': normalizedStatus,
                  'source': source,
                  'addedAt': FieldValue.serverTimestamp(),
                  'updatedAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String docId, Map<String, dynamic> data) {
    final itemIdController = TextEditingController(text: data['itemId']?.toString() ?? '');
    final nameController = TextEditingController(text: data['name']);
    final categoryController = TextEditingController(text: data['category']);
    String selectedType = data['type'] ?? data['category'] ?? 'Mobility Aid';
    categoryController.text = selectedType;
    final descriptionController = TextEditingController(text: data['description']);
    final conditionController = TextEditingController(text: data['condition']);
    final quantityController = TextEditingController(text: data['quantity']?.toString());
    final locationController = TextEditingController(text: data['location']);
    final priceController = TextEditingController(
      text: data['rentalPricePerDay']?.toString() ?? '',
    );
    final tagsController = TextEditingController(
      text: data['tags'] != null ? (data['tags'] as List).join(', ') : '',
    );
    final imagesController = TextEditingController(
      text: data['images'] != null ? (data['images'] as List).join(', ') : '',
    );
    String selectedStatus = data['status'] ?? 'available';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemIdController,
                decoration: const InputDecoration(
                  labelText: 'Item ID / Code *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type *',
                  border: OutlineInputBorder(),
                ),
                items: _categoryFilters
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  selectedType = value ?? selectedType;
                  categoryController.text = selectedType;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: conditionController,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rental Price Per Day (SR)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imagesController,
                decoration: const InputDecoration(
                  labelText: 'Image URLs (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                ),
                items: ['available', 'rented', 'maintenance', 'donated']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status[0].toUpperCase() + status.substring(1)),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (itemIdController.text.isEmpty ||
                  nameController.text.isEmpty ||
                  categoryController.text.isEmpty ||
                  quantityController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill required fields')),
                );
                return;
              }
              
              // Validate and ensure quantity is > 0
              final qty = int.tryParse(quantityController.text) ?? 0;
              if (qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quantity must be greater than 0')),
                );
                return;
              }

              try {
                final tags = tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final images = imagesController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

                final price = priceController.text.isNotEmpty
                  ? double.tryParse(priceController.text)
                  : null;

                final normalizedStatus = selectedStatus.toLowerCase();
                final source = normalizedStatus == 'donated' ? 'donation' : (data['source'] ?? 'manual');

                await FirebaseFirestore.instance
                    .collection('inventory')
                    .doc(docId)
                    .update({
                  'itemId': itemIdController.text.trim(),
                  'name': nameController.text,
                  'type': selectedType,
                  'category': categoryController.text.isNotEmpty ? categoryController.text : selectedType,
                  'description': descriptionController.text,
                  'condition': conditionController.text,
                  'quantity': qty,
                  'location': locationController.text,
                  'rentalPricePerDay': price,
                  'tags': tags,
                  'images': images,
                  'status': normalizedStatus,
                  'availabilityStatus': normalizedStatus,
                  'source': source,
                  'updatedAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003465),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('inventory')
                    .doc(docId)
                    .delete();

                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
