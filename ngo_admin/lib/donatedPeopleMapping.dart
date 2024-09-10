import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_admin/volunteer_assignment.dart';

class DonatedPeopleList extends StatefulWidget {
  final String? options;
  final String? queryId;
  const DonatedPeopleList({super.key, required this.options, this.queryId});

  @override
  State<DonatedPeopleList> createState() => _DonatedPeopleListState();
}

class _DonatedPeopleListState extends State<DonatedPeopleList> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("List of people Donated"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("requirements")
              .where('options', isEqualTo: widget.options.toString())
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.active) {
              return ListView.builder(
                  itemCount: snapshots.data?.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AssignVolunteerToQueryAndRequirement(
                                        queryId: widget.queryId,
                                        requirementId: snapshots
                                            .data?.docs[index].id
                                            .toString(),
                                        lat: double.parse(snapshots
                                            .data?.docs[index]['latitude']),
                                        long: double.parse(snapshots
                                            .data?.docs[index]['longitude']))));
                      },
                      child: Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "${snapshots.data?.docs[index]['pname'].toString()}",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.red, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${snapshots.data?.docs[index]['pdes'].toString()}",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.blue, fontSize: 20),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Sample image will be",
                                style: GoogleFonts.aBeeZee(fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: "hell",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.blue))),
                              Image.network(
                                "${snapshots.data?.docs[index]['imageUrl'].toString()}",
                                width: double.infinity,
                                height: height / 2,
                                fit: BoxFit.fill,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
            if (snapshots.hasError) {
              return SizedBox();
            }
            return SizedBox();
          }),
    );
  }

  Future<String> getCurrentPlace(
      {required double latitude, required double longitude}) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latitude, longitude);
    return "${placeMarks[0].street} ${placeMarks[0].name}";
  }
}
