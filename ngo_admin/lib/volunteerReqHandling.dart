import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerRequestHandler extends StatefulWidget {
  const VolunteerRequestHandler({super.key});

  @override
  State<VolunteerRequestHandler> createState() =>
      _VolunteerRequestHandlerState();
}

class _VolunteerRequestHandlerState extends State<VolunteerRequestHandler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("VOLUNTEER REQUEST")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text("FINAL CALL"),
                            content: Text(
                                "Are you sure to accept ${snapshot.data?.docs[index]['name'].toString()} as Volunteer"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path:
                                          '${snapshot.data!.docs[index]['email'].toString()}',
                                      queryParameters: {
                                        'subject':
                                            'YOUR\t\tREQUEST\t\tACCEPTED',
                                        'body':
                                            'YOUR\t\tPASSWORD\t\tIS\t\t:\t\t${snapshot.data!.docs[index]['phoneNumBer'].toString()}',
                                      },
                                    );

                                    await launchUrl(emailUri);
                                    User user = (await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email:
                                                    '${snapshot.data!.docs[index]['email'].toString()}',
                                                password:
                                                    '${snapshot.data!.docs[index]['phoneNumBer'].toString()}'))
                                        .user!;

                                    await FirebaseFirestore.instance
                                        .collection('volunteers')
                                        .add({
                                      'email':
                                          '${snapshot.data!.docs[index]['email'].toString()}',
                                      'name':
                                          '${snapshot.data?.docs[index]['name'].toString()}',
                                      'phone':
                                          '${snapshot.data!.docs[index]['phoneNumBer'].toString()}',
                                      'lat': '',
                                      'long': '',
                                      'id': user.uid.toString(),
                                    });
                                  },
                                  child: Text("ACCEPT")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("REJECT"))
                            ],
                          );
                        });
                  },
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextClass(
                              txt: "${snapshot.data?.docs[index]['name']}"),
                          SizedBox(height: 15),
                          TextClass(
                              txt: "${snapshot.data?.docs[index]['email']}"),
                          SizedBox(height: 15),
                          TextClass(
                              txt:
                                  "${snapshot.data?.docs[index]['phoneNumBer']}"),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data?.docs.length);
        });
  }
}

class TextClass extends StatelessWidget {
  final String txt;
  const TextClass({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${txt}",
      style: GoogleFonts.aBeeZee(),
    );
  }
}
