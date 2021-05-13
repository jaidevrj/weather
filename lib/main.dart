import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/details.dart';
import 'dart:async';
import 'dart:convert';
import 'widgets/main_widget.dart';



class WeatherInfo{
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final int humidity;
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
  factory WeatherInfo.fromJson(Map<String,dynamic> json){
    return WeatherInfo(
      location: json['name'],
      temp: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      weather: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
    );
  }
}
void main() =>runApp(
  MaterialApp(
    title:"Weather App",
    debugShowCheckedModeBanner: false,
    home: Details(),
  )
);
class MyApp extends StatefulWidget {
  String zipCode;
  String countryCode;
  MyApp({
    this.zipCode,this.countryCode
  });
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<WeatherInfo> futureWeather;
  @override
  void initState() {
    super.initState();
    futureWeather=fetchWeather();
  }
  Future<WeatherInfo> fetchWeather () async {
  final zipCode=widget.zipCode;
  final countryCode=widget.countryCode;
  final apikey="1140344de1917bd9a0ea248450fdcce9";
  final requestUrl="http://api.openweathermap.org/data/2.5/weather?zip=${zipCode},${countryCode}&units=imperial&appid=${apikey}";
  final response = await http.get(Uri.parse(requestUrl));
  
  if(response.statusCode ==200) {
    //print(response.body);
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
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            return MainWidget(
              location: snapshot.data.location,
              temp: snapshot.data.temp,
              tempMin: snapshot.data.tempMin,
              tempMax: snapshot.data.tempMax,
              weather: snapshot.data.weather,
              humidity: snapshot.data.humidity,
              windSpeed:snapshot.data.windSpeed,
            );
          } else if(snapshot.hasError) {
            return Center(
              child: Text("error:Check your Internet Connection   Or   ${snapshot.error}"),
            );
          }
          return Center(child:CircularProgressIndicator());
        },
      ),
    );
  }
}