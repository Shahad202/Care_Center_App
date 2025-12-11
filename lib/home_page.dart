import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Center'),
        backgroundColor:  const Color(0xFF0A66C2),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
          }, child: const Text('Login', style: TextStyle(color: Colors.white),)
          ),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
          }, child:  const Text('Sign Up', style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Center(
        child: Text('Welcome Guest! Please Login or Signup.', style: Theme.of(context).textTheme.titleMedium,),
      ),
    );
  }
}