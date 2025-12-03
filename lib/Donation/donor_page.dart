import 'package:flutter/material.dart';
import 'donate_tab.dart';
import 'tracking_tab.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});
  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF003465),
              ),
              child: const Center(
                child: Text(
                  'App Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text(
                'Inventory Management',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text(
                'Donations',
                style: TextStyle(fontSize: 14),
              ),
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
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildTabBar(),
          const SizedBox(height: 30),
          Expanded(
            child: _selectedTabIndex == 2
                ? const TrackingTabPage()
                : SingleChildScrollView(child: _buildTabContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 63,
      width: double.infinity,
      color: const Color(0xFF003465),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              padding: const EdgeInsets.all(18), // تصحيح الخطأ
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(child: _tabBtn('About', 0)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Donate', 1)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Tracking', 2)),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final selected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: selected
              ? [const BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 6)]
              : null,
          color: selected ? const Color(0xFF003465) : const Color(0xFFF7FBFF),
          border: selected ? null : Border.all(color: const Color(0xFFAAA6B2), width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFFF7FBFF) : const Color(0xFFAAA6B2),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildAboutContent();
      case 1:
        return DonateTabPage(onDonationAdded: (_) {});
      case 2:
        return const SizedBox.shrink();
      default:
        return _buildAboutContent();
    }
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _makeDifferenceCard(),
          const SizedBox(height: 30),
          _howItWorks(),
          const SizedBox(height: 30),
          _beforeDonateCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _makeDifferenceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x14003465), offset: Offset(0, 6), blurRadius: 16),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003465), Color(0xFF1874CF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make a Difference',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Your donated equipment can change someone's life.",
            style: TextStyle(
              color: Color(0xFFEAF2FA),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _howItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How It Works',
          style: TextStyle(color: Color(0xFF003465), fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),
        _stepCard(
          'lib/images/Level1.png',
          'Submit Your Donation',
          'Fill out the donation form with equipment details and photos',
        ),
        const SizedBox(height: 30),
        _stepCard(
          'lib/images/2circled.png',
          'Admin Review',
          'Our team will review your submission within 24-48 hours',
        ),
        const SizedBox(height: 30),
        _stepCard(
          'lib/images/Circled3.png',
          'Help Someone',
          'Once approved, your equipment will be available for those in need',
        ),
      ],
    );
  }

  Widget _stepCard(String img, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [BoxShadow(color: Color(0x10000000), offset: Offset(0, 2), blurRadius: 4)],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF003465),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _beforeDonateCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFFFF1DE),
        border: Border.all(color: const Color.fromARGB(255, 250, 176, 72), width: 1.85),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bullet('Ensure the equipment is clean and in working condition.'),
          const SizedBox(height: 16),
          _bullet('Provide clear, well-lit photos from multiple angles.'),
          const SizedBox(height: 16),
          _bullet('Be honest about the equipment condition and any defects.'),
          const SizedBox(height: 16),
          _bullet('Include all accessories and user manuals if available.'),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.5,
          height: 8.5,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(212, 133, 18, 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}