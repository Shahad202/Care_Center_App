// TODO Implement this library.
import 'package:flutter/material.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Equipment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _itemCard(
            context,
            title: "Wheelchair",
            description: "Standard wheelchair for mobility",
            imageName: "wheelchair.png", // <<<<< حطي الصورة بهذا الاسم
          ),
          const SizedBox(height: 16),

          _itemCard(
            context,
            title: "Hospital Bed",
            description: "Electric adjustable medical bed",
            imageName: "bed.png", // <<<<< حطي الصورة بهذا الاسم
          ),
          const SizedBox(height: 16),

          _itemCard(
            context,
            title: "Crutches",
            description: "Underarm crutches – adjustable height",
            imageName: "crutches.png", // <<<<< حطي الصورة بهذا الاسم
          ),
        ],
      ),
    );
  }

  Widget _itemCard(
    context, {
    required String title,
    required String description,
    required String imageName,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // صورة الجهاز
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: DecorationImage(
                image: AssetImage("assets/images/$imageName"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          // زر الحجز
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/dates");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A66C2),
            ),
            child: const Text("Reserve"),
          ),
        ],
      ),
    );
  }
}
