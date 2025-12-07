import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'signup.dart';
import 'reservation/reservation.dart';
import 'main.dart';
import 'Donation/donor_page.dart';
import 'reservation/reservation_dates_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  // Instance of AuthService 
  final AuthService _authService = AuthService();
  // Loading state
  bool _isLoading = false;

  @override

  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // input email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value == null || value.isEmpty ){
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)){
                    return 'Enter a valid email';
                  }
                  return null;
                }
              ),
              const SizedBox(height: 16),
          
              // input password
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border:OutlineInputBorder()
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter your password';
                  }
                  // password min 6 characters
                  if (value.length < 6){
                    return 'Password must be at least 6 charecters';
                  }
                  return null;
                },
              ),
               const SizedBox(height: 16),
          
               // login button
               _isLoading
               ? const CircularProgressIndicator()
               : ElevatedButton(onPressed: _login,
                child: const Text('Login', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A66C2)),
                ),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())
                  );
                }, child: const Text("Dont have an account? Sign Up")
                )
            ],
            ),
        ), 
       ),
      ),
    );
  }

  // login function
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()){
      // form is invalid, dont proceed
      return;
    }
    
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();


    try {
    final user  = await _authService.signIn(email: email, password:password);

    setState(() => _isLoading = false);

    if (user != null){

      // get users date from the firestore 
      final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();


    if (doc.exists){
      final name= doc['name'];
      final role = doc['role'];


       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Welcome, $name!')));

        // Navigate based on role:
        if (role == 'Admin'){
          // to remove the login page from history, so user can't press back and return to guest home or login screen sisnce there are already buttons for these
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage(userName: name)));
        } else if (role == 'Donor'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DonorPage(userName: name)));
        } else if (role == 'Renter'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RenterPage(userName: name)));
        }
      }
    }  
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    print('Login error details: $e'); // طباعة التفاصيل
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: ${e.toString()}'))
    );
  }
}

}