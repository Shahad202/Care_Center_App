import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/reservation/reservation_success_screen.dart';
import 'package:project444/reservation/reservation_dates_screen.dart';



class ReservationFormPage extends StatefulWidget {
  const ReservationFormPage({super.key});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final TextEditingController _searchController = TextEditingController();
  String _filterSource = 'all';
  String _search = '';
  Map<String, dynamic>? _selectedItem;
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _search = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
void _selectItem(Map<String, dynamic> item, String id) {
  _selectedItem = {...item, 'id': id};
  int bottomSheetQuantity = 1; // separate local state for bottom sheet
  final available = (item['quantity'] ?? 0) as int;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] ?? 'Unnamed',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(item['description'] ?? '',
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Text('Available: $available',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Quantity:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: bottomSheetQuantity > 1
                          ? () => setModalState(() => bottomSheetQuantity--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$bottomSheetQuantity',
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: bottomSheetQuantity < available
                          ? () => setModalState(() => bottomSheetQuantity++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    const SizedBox(width: 8),
                    if (bottomSheetQuantity >= available)
                      const Text(' (max)',
                          style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: available > 0
                        ? () {
                            Navigator.pop(context); // close bottom sheet
                            // Pass the correct bottom sheet quantity to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReservationDatesScreen(
                                  inventoryItemId: item['id'],
                                  itemName: item['name'],
                                  requestedQuantity: bottomSheetQuantity,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003465)),
                    child: const Text('Reserve this item'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}


  

  List<Map<String, dynamic>> _applyFilters(List<QueryDocumentSnapshot> docs) {
    final lowerSearch = _search;
    final sourceFilter = _filterSource;
    final results = docs.map((d) {
      final data = d.data()! as Map<String, dynamic>;
      return {...data, 'id': d.id};
    }).where((item) {
  final rawSource = item['source'];
  final source = (rawSource == 'donation') ? 'donation' : 'center';
  if (sourceFilter != 'all' && source != sourceFilter) return false;

  
  if ((item['status'] ?? '').toString().toLowerCase() != 'available') return false;

  
  if (lowerSearch.isEmpty) return true;
  final name = (item['name'] ?? '').toString().toLowerCase();
  final desc = (item['description'] ?? '').toString().toLowerCase();
  return name.contains(lowerSearch) || desc.contains(lowerSearch);
  })
  .toList();

    results.sort((a, b) =>
        (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Equipment'),
        backgroundColor: const Color(0xFF003465),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search equipment by name or description',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Filter:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filterSource,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'donation', child: Text('Donated')),
                    DropdownMenuItem(value: 'center', child: Text('Center')),
                  ],
                  onChanged: (v) => setState(() => _filterSource = v ?? 'all'),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    child: const Text('Clear')),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('inventory').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  final items = _applyFilters(docs);

                  if (items.isEmpty) {
                    return const Center(child: Text('No matching items'));
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final qty = (item['quantity'] ?? 0) as int;
                      return Card(
                        child: ListTile(
                          leading: item['imageIds'] is List &&
                                  (item['imageIds'] as List).isNotEmpty
                              ? const Icon(Icons.image)
                              : const Icon(Icons.inventory),
                          title: Text(item['name'] ?? 'Unnamed'),
                          subtitle: Text(
                              '${item['source'] == 'donation' ? 'Donated' : 'Center'} • ${item['condition'] ?? ''} • Available: $qty'),
                          trailing: qty > 0
                              ? ElevatedButton(
                                  onPressed: () => _selectItem(item, item['id']),
                                  child: const Text('Select'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF1874CF)),
                                )
                              : const Text('Out',
                                  style: TextStyle(color: Colors.red)),
                          onTap: () => _selectItem(item, item['id']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






















