import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssignVolunteerToQueryAndRequirement extends StatefulWidget {
  final String? queryId;
  final String? requirementId;
  final double lat,long;
  const AssignVolunteerToQueryAndRequirement({super.key, required this.queryId, required this.requirementId, required this.lat, required this.long});

  @override
  State<AssignVolunteerToQueryAndRequirement> createState() => _AssignVolunteerToQueryAndRequirementState();
}

class _AssignVolunteerToQueryAndRequirementState extends State<AssignVolunteerToQueryAndRequirement> {


  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Radius of the Earth in kilometers

  // Convert degrees to radians
  double toRadians(double degree) => degree * pi / 180;

  double dlat = toRadians(lat2 - lat1);
  double dlon = toRadians(lon2 - lon1);

  double a = sin(dlat / 2) * sin(dlat / 2) +
      cos(toRadians(lat1)) * cos(toRadians(lat2)) *
      sin(dlon / 2) * sin(dlon / 2);
  
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Distance in kilometers
  double distance = R * c;

  return distance;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Volunteer'),
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('volunteers').snapshots(), 
        builder: (context,snapshots){
          if(snapshots.hasData){

            //volunteer list
            List<Map<String, dynamic>> volunteer = snapshots.data!.docs.map((doc) {
      return doc.data() as Map<String, dynamic>; 
    }).toList(); 
            print(volunteer);
            volunteer = volunteer.where((val) => val['isAvailable'] == true).toList();
            //calculating distance of each volunteer with current donated product
            volunteer.forEach((vol){
              vol['distance'] = calculateDistance(widget.lat, widget.long, vol['lat'], vol['long']);
            });
            volunteer.sort((a, b) => a['distance'].compareTo(b['distance']));
            if (volunteer.length > 5) {
    volunteer = volunteer.sublist(0, 5);
  }
            print(volunteer);
            return ListView.builder(
              itemCount: volunteer.length,
              itemBuilder: (context,Index){
                return GestureDetector(

                  onTap: ()async{
                    DocumentSnapshot<Map<String, dynamic>> queryDocsnap = await FirebaseFirestore.instance.collection('query').doc(widget.queryId).get() ;
                    DocumentSnapshot<Map<String, dynamic>> reqDocsnap = await FirebaseFirestore.instance.collection('requirements').doc(widget.requirementId).get();

                    Map<String, dynamic>? queryDoc = queryDocsnap.data();
                    Map<String, dynamic>? reqDoc = reqDocsnap.data();

                    FirebaseFirestore.instance.collection('query').doc(widget.queryId).delete();
                    FirebaseFirestore.instance.collection('requirements').doc(widget.requirementId).delete();

                    DocumentReference docRef = await FirebaseFirestore.instance.collection('assigned').add({
                      'query' : queryDoc,
                      'requirement' : reqDoc,
                      'volunteer' : volunteer[Index],
                    });

                    String assignedId = docRef.id;

                    FirebaseFirestore.instance.collection('volunteers').doc(volunteer[Index]['id']).update({
                      'assignments' : FieldValue.arrayUnion([assignedId]),
                      'isAvailable' : false
                    });
                  },

                  child: ListTile(
                    title: Text(volunteer[Index]['name']),
                    subtitle: Text('distance: ${volunteer[Index]['distance'].toString()} km'),
                  ),
                );
              }
            );
          }
          else{
            return Text("no data");
          }
        }),
    );
  }
}