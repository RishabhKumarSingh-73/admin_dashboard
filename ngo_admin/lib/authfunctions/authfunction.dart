import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ngo_admin/HomePage.dart';

class AuthFunction {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> register(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required BuildContext context}) async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      print("user is not null");
      await _firestore.collection("ADMIN PANEL DETAILS").doc().set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'userId': user.uid.toString()
      }).then((v) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("REGISTERED SUCCESSFULLY")));
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => Homepage()));
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("ERror is ${e.toString()}")));
    }
  }
}
