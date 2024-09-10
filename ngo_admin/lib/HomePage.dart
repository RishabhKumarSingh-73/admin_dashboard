import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_admin/donatedPeopleMapping.dart';
import 'package:ngo_admin/volunteerReqHandling.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  List<Widget> screens = [Home(), VolunteerRequestHandler()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _currentIndex = index;
            setState(() {
              _currentIndex;
            });
          },
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "HOME"),
            BottomNavigationBarItem(
                icon: Icon(Icons.hail), label: "VOLUNTEER REQUEST")
          ]),
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: screens[_currentIndex],
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("query").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  print("Clicked card ${snapshot.data?.docs.length}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => DonatedPeopleList(
                                options: snapshot.data?.docs[index]['options']
                                    .toString(),
                                queryId:
                                    snapshot.data?.docs[index].id.toString(),
                              )));
                },
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                  "${snapshot.data?.docs[index]['name'][0].toString().toUpperCase()}"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${snapshot.data?.docs[index]['name'].toString()}",
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 60),
                          child: Text(
                            "${snapshot.data?.docs[index]['phone'].toString()}",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.grey, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 60),
                          child: Text(
                            "${snapshot.data?.docs[index]['queryname'].toString()}",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.red, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 60),
                          child: Text(
                            "${snapshot.data?.docs[index]['options'].toString()}",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.blue, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 60),
                          child: Text(
                            "${snapshot.data?.docs[index]['discription'].toString()}",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.purple, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data?.docs.length,
          );
        });
  }
}
