import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'donation_form.dart';
import 'donor_page.dart';
import 'tracking_tab.dart';
import 'donation_item.dart';

class DonateTabPage extends StatelessWidget {
  final Function(DonationItem)? onDonationAdded;

  const DonateTabPage({super.key, this.onDonationAdded});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          _buildShareEquipmentCard(),
          const SizedBox(height: 38),
          _buildWhatYouCanDonateSection(),
          const SizedBox(height: 38),
          _buildAddDonationButton(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildShareEquipmentCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14003465),
            offset: Offset(0, 6),
            blurRadius: 16,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF003465),
            Color(0xFF1874CF),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 77,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/Trusticon.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Share Your Equipment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Help those in need by donating assistive equipment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFEAF2FA),
              fontFamily: 'Inter',
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatYouCanDonateSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What You Can Donate',
            style: TextStyle(
              color: Color.fromRGBO(212, 133, 18, 1),
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _donationItem('lib/images/Electricwheelchair.png', 'Wheelchairs'),
          const SizedBox(height: 15),
          _donationItem('lib/images/Walker.png', 'Walkers & Crutches'),
          const SizedBox(height: 15),
          _donationItem('lib/images/Sphygmomanometer.png', 'Blood pressure monitors'),
          const SizedBox(height: 15),
          _donationItem('lib/images/Glucometer.png', 'Glucose meters'),
          const SizedBox(height: 15),
          _donationItem('lib/images/Massagetable.png', 'Physical therapy equipment'),
          const SizedBox(height: 15),
          Row(
            children: [
              Transform.rotate(
                angle: 90 * (math.pi / 180),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/More.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'And more...',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _donationItem(String imagePath, String text) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddDonationButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DonationFormPage(),
            ),
          );

            if (result is DonationItem) {
  onDonationAdded?.call(result);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Donation stored. Check Tracking tab.'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.06),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(255, 204, 0, 1),
                Color.fromRGBO(255, 180, 0, 1),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: const Text(
            'Add Donation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(247, 251, 255, 1),
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}