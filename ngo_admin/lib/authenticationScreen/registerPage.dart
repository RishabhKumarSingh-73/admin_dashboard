import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ngo_admin/authfunctions/authfunction.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  final TextEditingController name=TextEditingController();
  final TextEditingController phoneNumber=TextEditingController();
  final TextEditingController emailId=TextEditingController();
  final TextEditingController password=TextEditingController();
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;


    return Scaffold(

      appBar: AppBar(
        title: Text("Register Page"),
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
                  controller: name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "NAME",
                      labelText: "NAME"

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



              IntlPhoneField(
                initialCountryCode: 'IN',
                controller: phoneNumber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(




                  )
                ),

              ),
                SizedBox(height: 30,),


                ElevatedButton(onPressed: (){



                  if(_formKey.currentState!.validate())
                    {
                      print("Clicked");

                      AuthFunction.register(name: name.text, email: emailId.text, password: password.text, phone: phoneNumber.text,context: context);
                    }
                }, child: Text("SUBMIT")),


                SizedBox(height: 30,),





              ],
            ),
          ),
        ),
      ),

    );
  }
}
