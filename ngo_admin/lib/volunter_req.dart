import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class maill extends StatefulWidget {
  const maill({super.key});

  @override
  State<maill> createState() => _maillState();
}

class _maillState extends State<maill> {
  String mail = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("volunteer request"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('VOLUNTEER REQUEST')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return Card(
                  child: Column(
                    children: [
                      Text(
                        'name: ${snapshot.data!.docs[index]['name'].toString()}',
                      ),
                      Text(
                        'email: ${snapshot.data!.docs[index]['email'].toString()}',
                      ),
                      Text(
                        'age: ${snapshot.data!.docs[index]['age'].toString()}',
                      ),
                      Text(
                        'phone number: ${snapshot.data!.docs[index]['phoneNumBer'].toString()}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  User user = (await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                    email:
                                        '${snapshot.data!.docs[index]['email'].toString()}',
                                    password:
                                        '${snapshot.data!.docs[index]['phoneNumBer'].toString()}',
                                  ))
                                      .user!;

                                  if (user != null) {
                                    user.updateDisplayName("volunteer");
                                    // Navigator.of(context).pop();
                                    print(
                                        "user details is ${user.displayName}");
                                  } else {
                                    print("User authentication faliled");

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("NULL")));
                                  }
                                } on FirebaseAuthException catch (e) {
                                  String x = e.code.toString();
                                } catch (e) {
                                  print(e);
                                }
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path:
                                      '${snapshot.data!.docs[index]['email'].toString()}',
                                  queryParameters: {
                                    'subject': 'YOUR\t\tREQUEST\t\tACCEPTED',
                                    'body':
                                        'YOUR\t\tPASSWORD\t\tIS\t\t:\t\t${snapshot.data!.docs[index]['phoneNumBer'].toString()}',
                                  },
                                );

                                await launchUrl(emailUri);
                              },
                              child: Text('accept')),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('VOLUNTEER REQUEST')
                                      .doc(doc.id)
                                      .delete();
                                  print("Document successfully deleted!");
                                } catch (e) {
                                  print("Error deleting document: $e");
                                }
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path:
                                      '${snapshot.data!.docs[index]['email'].toString()}',
                                  queryParameters: {
                                    'subject': 'YOUR\t\tREQUEST\t\tREJECTED',
                                    'body':
                                        'YOUR\t\tREQUEST\t\tREJECTED\t\tTRY\t\tAGAIN\t\tAFTER\t\tSOMETIMES',
                                  },
                                );

                                await launchUrl(emailUri);
                              },
                              child: Text('decline'))
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          } else {
            print('oombu');
            return SizedBox();
          }
        },
      ),
    );
  }
}
