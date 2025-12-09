import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/Reservation/reservation_item.dart';

class ReservationService {
  final _firestore = FirebaseFirestore.instance;

  Future<ReservationItem> addReservation({
    required String equipmentName,
    required int quantity,
    String? notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final docRef = await _firestore.collection('reservations').add({
      'equipmentName': equipmentName,
      'quantity': quantity,
      'notes': notes ?? '',
      'userId': user.uid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final snap = await docRef.get();
    return ReservationItem.fromDoc(snap);
  }
}
