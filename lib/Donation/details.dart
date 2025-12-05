import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/donation_image.dart';

class DonationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> donation;

  const DonationDetailsPage({
    super.key,
    required this.donation,
  });

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
      case 'like new':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF76C893);
      case 'fair':
        return const Color(0xFFFFA726);
      case 'needs repair':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA726);
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
      case 'in review':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFAAA6B2);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      if (date is Timestamp) {
        final dt = date.toDate();
        return '${dt.day} ${_getMonthName(dt.month)} ${dt.year}';
      }
      if (date is DateTime) {
        return '${date.day} ${_getMonthName(date.month)} ${date.year}';
      }
      if (date is String) {
        final parsed = DateTime.tryParse(date);
        if (parsed != null) {
          return '${parsed.day} ${_getMonthName(parsed.month)} ${parsed.year}';
        }
      }
      return date.toString();
    } catch (_) {
      return 'N/A';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final imageIds = (widget.donation['imageIds'] as List?)?.cast<String>() ?? [];
    final hasMultipleImages = imageIds.length > 1;
    final statusColor = _getStatusColor(widget.donation['status'] ?? 'pending');
    final conditionColor = _getConditionColor(widget.donation['condition'] ?? 'good');

    print('\n=== Details Page Build ===');
    print('Image IDs: ${imageIds.length}');

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF003465),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: imageIds.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() => _currentImageIndex = index);
                          },
                          itemCount: imageIds.length,
                          itemBuilder: (context, index) {
                            return _buildImageFromHive(imageIds[index]);
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.25),
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        if (hasMultipleImages && _currentImageIndex > 0)
                          Positioned(
                            left: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _arrowButton(
                                Icons.arrow_back_ios_new,
                                () => _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                              ),
                            ),
                          ),
                        if (hasMultipleImages &&
                            _currentImageIndex < imageIds.length - 1)
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: _arrowButton(
                                Icons.arrow_forward_ios,
                                () => _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                              ),
                            ),
                          ),
                        if (hasMultipleImages)
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_currentImageIndex + 1} / ${imageIds.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      color: const Color(0xFF003465),
                      child: const Center(
                        child: Icon(
                          Icons.medical_services_outlined,
                          size: 100,
                          color: Colors.white24,
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF7FBFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.donation['itemName'] ?? 'Unknown Item',
                                style: const TextStyle(
                                  color: Color(0xFF003465),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.6),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle, color: statusColor, size: 12),
                                    const SizedBox(width: 6),
                                    Text(
                                      _getStatusText(
                                          widget.donation['status'] ?? 'pending'),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _sectionTitle('Details'),
                    const SizedBox(height: 16),
                    _detailCard([
                      _detailRow(Icons.inventory_2_outlined, 'Item Name',
                          widget.donation['itemName']),
                      _detailRow(Icons.verified, 'Condition',
                          widget.donation['condition']),
                      _detailRow(Icons.numbers, 'Quantity',
                          widget.donation['quantity']?.toString()),
                      _detailRow(Icons.location_on_outlined, 'Location',
                          widget.donation['location']),
                      _detailRow(
                        Icons.calendar_today_outlined,
                        'Created',
                        _formatDate(widget.donation['createdAt']),
                      ),
                    ]),
                    if (widget.donation['description'] != null &&
                        widget.donation['description'].toString().isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('Description'),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 80),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE6E8EB),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.donation['description'],
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          textWidthBasis: TextWidthBasis.parent,
                          style: const TextStyle(
                            color: Color(0xFF424242),
                            fontSize: 15,
                            height: 1.7,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFromHive(String imageId) {
    return FutureBuilder<DonationImage?>(
      future: HiveService.getImage(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeholderIcon();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _placeholderIcon();
        }

        final image = snapshot.data!;

        return Image.memory(
          Uint8List.fromList(image.imageBytes),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderIcon();
          },
        );
      },
    );
  }

  Widget _placeholderIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.medical_services_outlined,
          color: Color(0xFF003465),
          size: 60,
        ),
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF003465),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003465).withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: children
            .expand((w) => [w, const SizedBox(height: 12)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, dynamic value) {
    if (value == null) return const SizedBox.shrink();
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF003465).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF003465), size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFAAA6B2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),
                style: const TextStyle(
                  color: Color(0xFF003465),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}