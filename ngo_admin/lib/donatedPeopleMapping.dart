import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonatedPeopleList extends StatefulWidget {
  final String? options;
  const DonatedPeopleList({super.key,required this.options});

  @override
  State<DonatedPeopleList> createState() => _DonatedPeopleListState();
}

class _DonatedPeopleListState extends State<DonatedPeopleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(



      appBar: AppBar(
        title: Text("List of people Donated"),
      ),
      

      body: StreamBuilder(stream: FirebaseFirestore.instance.collection("requirements").where('options',isEqualTo: widget.options.toString()).snapshots(), builder: (context,snapshots)
      {
        
        if(snapshots.connectionState==ConnectionState.active)
          {
            return ListView.builder(itemBuilder: (context,index){
              return Text("${snapshots.data?.docs[index]["pname"].toString()}");
            },itemCount: snapshots.data?.docs.length,);
          }
        if(snapshots.hasError)
          {
            return SizedBox();
          }
        return SizedBox();
      }),
    );
  }
}
