
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_admin/HomePage.dart';
import 'package:ngo_admin/firebase_options.dart';

import 'authenticationScreen/loginScreen.dart';




Future<void> main() async
{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform
   );
   runApp(Admin());
}


class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Front(),
    );
  }
}


class Front extends StatefulWidget {
  const Front({super.key});

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 2),(){

       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>(FirebaseAuth.instance.currentUser==null)?LoginPage():Homepage()));

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Text("ADMIN NGO",style: GoogleFonts.aBeeZee(
          fontSize: 30
        ),),
      ),
    );
  }
}




