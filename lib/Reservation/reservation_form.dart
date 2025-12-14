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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  String _resolveSource(Map<String, dynamic> item) {
    final rawSource = item['source'];
    if (rawSource == null) return 'center';

    final s = rawSource.toString().toLowerCase();
    if (s == 'donation' || s == 'donated') {
      return 'donation';
    }
    return 'center';
  }

  List<Map<String, dynamic>> _applyFilters(
    List<QueryDocumentSnapshot> docs,
  ) {
    final results = docs
        .map((d) => {...(d.data() as Map<String, dynamic>), 'id': d.id})
        .where((item) {
          final statusAvailable =
              (item['status'] ?? '').toString().toLowerCase() == 'available';

          final source = _resolveSource(item);
          final sourceMatches =
              _filterSource == 'all' || source == _filterSource;

          final name =
              (item['name'] ?? '').toString().toLowerCase();
          final desc =
              (item['description'] ?? '').toString().toLowerCase();

          final searchMatches = _search.isEmpty ||
              name.contains(_search) ||
              desc.contains(_search);

          return statusAvailable && sourceMatches && searchMatches;
        })
        .toList();

    results.sort(
      (a, b) =>
          (a['name'] ?? '').toString().compareTo(
                (b['name'] ?? '').toString(),
              ),
    );

    return results;
  }

  void _selectItem(Map<String, dynamic> item) {
    int quantity = 1;
    final available = (item['quantity'] ?? 0) as int;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(item['description'] ?? ''),
                  const SizedBox(height: 12),
                  Text('Available: $available'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Text('Quantity:'),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setModalState(() => quantity--)
                            : null,
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: quantity < available
                            ? () => setModalState(() => quantity++)
                            : null,
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: available > 0
                          ? () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReservationDatesScreen(
                                    inventoryItemId: item['id'],
                                    itemName: item['name'],
                                    requestedQuantity: quantity,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003465),
                      ),
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
                hintText: 'Search equipment',
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
                    DropdownMenuItem(
                        value: 'all', child: Text('All')),
                    DropdownMenuItem(
                        value: 'donation', child: Text('Donated')),
                    DropdownMenuItem(
                        value: 'center', child: Text('Center')),
                  ],
                  onChanged: (v) =>
                      setState(() => _filterSource = v ?? 'all'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _searchController.clear(),
                  child: const Text('Clear'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('inventory')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items =
                      _applyFilters(snapshot.data!.docs);

                  if (items.isEmpty) {
                    return const Center(
                        child: Text('No matching items'));
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      final qty = (item['quantity'] ?? 0) as int;
                      final source = _resolveSource(item);

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.inventory),
                          title: Text(item['name'] ?? 'Unnamed'),
                          subtitle: Text(
                            '${source == 'donation' ? 'Donated' : 'Center'} • '
                            '${item['condition'] ?? ''} • Available: $qty',
                          ),
                          trailing: qty > 0
                              ? ElevatedButton(
                                  onPressed: () =>
                                      _selectItem(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF1874CF),
                                  ),
                                  child: const Text('Select'),
                                )
                              : const Text(
                                  'Out',
                                  style:
                                      TextStyle(color: Colors.red),
                                ),
                          onTap: () => _selectItem(item),
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

