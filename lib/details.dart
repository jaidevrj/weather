import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:weather_application/main.dart';
class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String zipCode;
  String countryCode;
  TextEditingController zipcodeController =TextEditingController();
  TextEditingController countrycodeController =TextEditingController();
  bool zipcodeValidate =false;
  bool countrycodeValidate =false;
  bool validateTextField(String zip,String cc) {
    if(zip.length<5 || !(isNumeric(zip))) {
      setState(() {
        zipcodeValidate=true;
      });
      return false;
    } else if(cc.length!=2 || isNumeric(cc)) {
      setState(() {
        if(zip.length>4){zipcodeValidate=false;} else {zipcodeValidate=true;}
        countrycodeValidate=true;
      });
      return false;
    }
    setState(() {
      zipcodeValidate=false;
      countrycodeValidate=false;
    });
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
       child: Center(
         child: Padding(
           padding: EdgeInsets.all(20.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               TextField(
                 controller: zipcodeController,
                 onChanged: (val){zipCode=val;},
                 decoration: InputDecoration(
                   errorText: zipcodeValidate? 'please enter a valid Zip-Code' : null,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                     ),
                 filled: true,
                 hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                 hintText: "Zip-Code or Pin-Code",
                 fillColor: Colors.white70
                 ),
               ),
               SizedBox(height: 15.0),
               TextField(
                 controller: countrycodeController,
                 onChanged: (val){
                   countryCode=val;
                 },
                 decoration: InputDecoration(
                   errorText: countrycodeValidate? "please enter a valid Country-Code" : null,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
                     ),
                 filled: true,
                 hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                 hintText: "2-Letter Country Code",
                 fillColor: Colors.white70
                 ),
               ),
               SizedBox(height: 15.0),
               ElevatedButton(
                 onPressed: (){
                   if(validateTextField(zipcodeController.text,countrycodeController.text)) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context)=>MyApp(zipCode:zipCode,countryCode:countryCode)),
                   );
                   }
               },
               child: Text("Submit"),
               ),
               SizedBox(height:20.0),
               Text(
                 "example for country code INDIA: in , USA: us",
                 style: TextStyle(
                   color: Colors.cyan,
                   fontSize: 16.0,
                   fontWeight: FontWeight.bold,
                   ),
               ),
             ],
             ),
         ),
       ),
     ),
    );
  }
}