import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'signup.dart';
import 'reservation/reservation.dart';
import 'Donation/donor_page.dart';
import 'reservation/reservation_dates_screen.dart';
import 'admin_dashboard.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  final AuthService _authService = AuthService();
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
              Image.asset('lib/images/Vector.png', height: 160),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
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
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter your password';
                  }
                  if (value.length < 6){
                    return 'Password must be at least 6 charecters';
                  }
                  return null;
                },
              ),
               const SizedBox(height: 16),
          
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()){
      return;
    }
    
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();


    try {
    final user  = await _authService.signIn(email: email, password:password);

    setState(() => _isLoading = false);

    if (user != null){

      final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();


    if (doc.exists){
      final name= doc['name'];
      final role = doc['role'];


       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Welcome, $name!')));

        if (role == 'Admin'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
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
    print('Login error details: $e'); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: ${e.toString()}'))
    );
  }
}

}