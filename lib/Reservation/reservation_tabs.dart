import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project444/signup.dart';
import 'package:project444/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project444/firebase_options.dart';
import 'package:project444/Reservation/reservation.dart';
import 'package:project444/donation/donor_page.dart';
import 'package:project444/profilePage.dart';
import 'dart:math' as math;
import 'package:project444/Reservation/reservation_form.dart';


class HowItWorksTab extends StatelessWidget {
  const HowItWorksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _stepCard('lib/images/Level1.png', 'Check Availability', 'Select Equipmetnt and Check avaialble dates.'),
          const SizedBox(height: 20),
          _stepCard('lib/images/2circled.png', 'Make a Reservation', 'Choose your Date Range or immediate pickup.'),
          const SizedBox(height: 20),
          _stepCard('lib/images/Circled3.png', 'Confirm Reservation', 'Submit Reservation and Await admin approval,'),
          const SizedBox(height: 20),
          _stepCard('lib/images/4circled.png', 'Rental Lifecycle', 'Track Status: Reserved -> Checked Out -> Returned -> Maintenance.'),
        ],
      ),
    );
  }



  Widget _stepCard( String img, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
        boxShadow: const [BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        )],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(image : DecorationImage(
              image: AssetImage(img),
              fit: BoxFit.contain,)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 8),
              Text(desc, style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              ),
            ],
          ),
          )  
      ],
      ),
    );
  }
}

class browsePage extends StatelessWidget {
  const browsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding:   const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        _buildReserveEquipmentCard(),
        const SizedBox(height: 20),
        _buildAvailableEquipmentSection(),
        const SizedBox(height: 20),
        _buildBrowseButton(context),
        const SizedBox(height: 20),
      ],)
    );
  }


  Widget _buildReserveEquipmentCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x14003465), offset: Offset(0, 6), blurRadius: 16)],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003465), Color(0xFF1874CF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 77,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('lib/images/Trusticon.png'), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reserve Assistive Equipment',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Browse available items and request a rental',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFEAF2FA), fontFamily: 'Inter', fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }



  Widget _buildAvailableEquipmentSection() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: Colors.white),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Equipment',
            style: TextStyle(color: Color.fromRGBO(212, 133, 18, 1), fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _equipmentItem('lib/images/Electricwheelchair.png', 'Wheelchairs'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Walker.png', 'Walkers & Crutches'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Massagetable.png', 'Medical Beds'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Sphygmomanometer.png', 'Monitors & Medical Devices'),
          const SizedBox(height: 15),
          Row(
            children: [
              Transform.rotate(
                angle: 90 * (math.pi / 180),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('lib/images/More.png'), fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text('And more...', style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontFamily: 'Inter', fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

    Widget _equipmentItem(String imagePath, String text) {
    return Row(
      children: [
        Container(width: 25, height: 25, decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain))),
        const SizedBox(width: 7),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 14))),
      ],
    );
  }


  Widget _buildBrowseButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationFormPage(),
              ),
            );
          },

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: const LinearGradient(colors: [Color(0xFFFFCC00), Color(0xFFFFB400)]),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: const Text('Browse Equipment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}




class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding:   EdgeInsets.symmetric(horizontal: 20.0),
    child: Text('Tracking Page - Under Construction',));
  }
}