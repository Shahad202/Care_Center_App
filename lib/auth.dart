import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// this class will handle all the authentication logic
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// register a new user with email and password
  Future<User?> signUp({required String email,required String password, required name, required contact, required role}) async {
    try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
           password: password);
      User? user = result.user;
      
      if (user !=null){
        // create afirestore document for the new user
        await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)  // use the uid as the doc id
        .set({
          'email': user.email,
          'role': role,
          'name': name,
          'contact': contact,          
        });
      } return user;
    } catch (e){
      print ('SignUp Error: $e');
      return null;
    }
  }

// Sign in an existing user
Future<User?> signIn(String email, String password) async {
  try{
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password);
      return result.user;
  } catch (e){
    print('Sign In Error:');
    print(e);
    rethrow;
  }
}

// Sign out the current user
Future<void> signOut() async {
  await _auth.signOut();
}

// Get the current user to use their info
User? get currentUser => _auth.currentUser;

}
