import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_admin/authenticationScreen/registerPage.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final TextEditingController emailId=TextEditingController();
  final TextEditingController password=TextEditingController();
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;


    return Scaffold(

      appBar: AppBar(
        title: Text("Login Page"),
      ),


      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: height/4,
                ),
                SizedBox(height: 20,),


                TextFormField(
                  controller: emailId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "EMAIL ID",
                    labelText: "EMAIL"

                  ),
                  validator: (val){
                    if(val!.isEmpty|| val==null)
                      {
                        return "PLEASE FILL THIS FIELD";
                      }
                  },

                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "PASSWORD",
                      labelText: "PASSWORD"

                  ),
                  validator: (val){
                    if(val!.isEmpty|| val==null)
                    {
                      return "PLEASE FILL THIS FIELD";
                    }
                  },

                ),
                SizedBox(height: 30,),


                ElevatedButton(onPressed: (){
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.text, password: password.text);
                }, child: Text("SUBMIT")),
                
                
                SizedBox(height: 30,),
                
                
                RichText(text: TextSpan(text: "Don't Have an account ?" ,style: GoogleFonts.aBeeZee(color: Colors.black),
                children: [
                  TextSpan(text: " Register Now ",style: GoogleFonts.aBeeZee(color: Colors.red),recognizer: TapGestureRecognizer()..onTap=(){

                    print("Navigated to  Register Page");
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>RegisterPage()));

                  })
                ]


                ))




              ],
            ),
          ),
        ),
      ),

    );
  }
}
