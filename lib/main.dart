import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splashscreen/splashscreen.dart';
import 'package:weather_application/details.dart';
import 'dart:async';
import 'dart:convert';
import 'widgets/main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherInfo {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final double humidity;
  final double windSpeed;

  WeatherInfo({
    @required this.location,
    @required this.temp,
    @required this.tempMin,
    @required this.tempMax,
    @required this.weather,
    @required this.humidity,
    @required this.windSpeed,
  });
  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      location: json['name'],
      temp: json['main']['temp'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      weather: json['weather'][0]['description'],
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,
      home: StartingScreen()));
}

class StartingScreen extends StatefulWidget {
  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  String _zipcode = null;
  Future<void> loadsharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tempzip = prefs.getString('zipcode') ?? null;
    setState(() {
      _zipcode = tempzip;
    });
  }

  @override
  void initState() {
    super.initState();
    loadsharedpref();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: _zipcode == null
          ? Details()
          : MyApp(zipCode: _zipcode, countryCode: "in"),
      title: new Text(
        'Weather App',
        textScaleFactor: 2,
      ),
      image: Image.asset('assests/logo.png'),
      loadingText: Text("Featching your temperature"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}

class MyApp extends StatefulWidget {
  String zipCode;
  String countryCode;
  MyApp({this.zipCode, this.countryCode});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<WeatherInfo> futureWeather;
  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  Future<WeatherInfo> fetchWeather() async {
    final zipCode = widget.zipCode;
    final countryCode = widget.countryCode;
    final apikey = "1140344de1917bd9a0ea248450fdcce9";
    final requestUrl =
        "http://api.openweathermap.org/data/2.5/weather?zip=${zipCode},${countryCode}&units=imperial&appid=${apikey}";
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error loading request URL info.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherInfo>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainWidget(
              location: snapshot.data.location,
              temp: snapshot.data.temp,
              tempMin: snapshot.data.tempMin,
              tempMax: snapshot.data.tempMax,
              weather: snapshot.data.weather,
              humidity: snapshot.data.humidity,
              windSpeed: snapshot.data.windSpeed,
              countryCode: widget.countryCode,
              zipCode: widget.zipCode,
            );
          } else if (snapshot.hasError) {
            print(snapshot.hasError);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                      "error:Check your Internet Connection   Or   ${snapshot.error}"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Details()));
                  },
                  child: Text(
                    "change location",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
