import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:weather_application/main.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:fluttertoast/fluttertoast.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String zipCode;
  String countryCode;
  PermissionStatus _permissionGranted;
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController countrycodeController = TextEditingController();
  bool zipcodeValidate = false;
  bool countrycodeValidate = false;
  bool validateTextField(String zip, String cc) {
    if (zip.length < 5 || !(isNumeric(zip))) {
      setState(() {
        zipcodeValidate = true;
      });
      return false;
    } else if (cc.length != 2 || isNumeric(cc)) {
      setState(() {
        if (zip.length > 4) {
          zipcodeValidate = false;
        } else {
          zipcodeValidate = true;
        }
        countrycodeValidate = true;
      });
      return false;
    }
    setState(() {
      zipcodeValidate = false;
      countrycodeValidate = false;
    });
    return true;
  }

  Future<void> setsharedpref(String zip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey('zipcode');
    if (CheckValue) {
      prefs.remove("zipcode");
      prefs.setString('zipcode', zip);
    } else {
      prefs.setString('zipcode', zip);
    }
  }

  Future<void> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;

    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var placemarks = await geocoding.placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    setsharedpref(placemarks[0].postalCode);
    setState(() {
      zipCode = placemarks[0].postalCode;
      countryCode = placemarks[0].isoCountryCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Location'),
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assests/logo.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await getLocation();
                          // print(zipCode);
                          // print(countryCode);
                          if (_permissionGranted == PermissionStatus.granted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyApp(
                                      zipCode: zipCode,
                                      countryCode: countryCode)),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please Allow Location permissions",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Text(
                          'Current Location',
                        ),
                        style: ButtonStyle(
                            // foregroundColor:
                            //     MaterialStateProperty.all(Colors.black),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            // backgroundColor:
                            //     MaterialStateProperty.all(Colors.blueAccent),
                            textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w400))),
                      ),
                    ),
                  ),
                  Text(
                    "Or",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: zipcodeController,
                    onChanged: (val) {
                      zipCode = val;
                    },
                    decoration: InputDecoration(
                        errorText: zipcodeValidate
                            ? 'please enter a valid Zip-Code'
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        hintText: "Zip-Code or Pin-Code",
                        fillColor: Colors.white70),
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: countrycodeController,
                    onChanged: (val) {
                      countryCode = val;
                    },
                    decoration: InputDecoration(
                        errorText: countrycodeValidate
                            ? "please enter a valid Country-Code"
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        hintText: "2-Letter Country Code",
                        fillColor: Colors.white70),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "example for country code INDIA: in , USA: us",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      if (validateTextField(
                          zipcodeController.text, countrycodeController.text)) {
                        setsharedpref(zipCode);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyApp(
                                  zipCode: zipCode, countryCode: countryCode)),
                        );
                      }
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
