import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/widgets/detailsCard.dart';

class WeatherData {
  final double maxTemp;
  final double humidity;
  final String description;
  final double windSpeed;
  final String date;

  WeatherData(
      {@required this.maxTemp,
      @required this.humidity,
      @required this.description,
      @required this.windSpeed,
      @required this.date});

  factory WeatherData.fromJson(dynamic json) {
    return WeatherData(
        description: json["weather"]["description"],
        humidity: json["rh"].toDouble(),
        maxTemp: json["max_temp"].toDouble(),
        windSpeed: json["wind_spd"].toDouble(),
        date: json["datetime"]);
  }

  @override
  String toString() {
    return '{ ${this.description}, ${this.humidity} }';
  }
}

class ForcastScreen extends StatefulWidget {
  String zipCode;
  String countryCode;
  ForcastScreen({@required this.zipCode, @required this.countryCode});
  @override
  _ForcastScreenState createState() => _ForcastScreenState();
}

class _ForcastScreenState extends State<ForcastScreen> {
  Future<List<WeatherData>> dataobs;
  Future<List<WeatherData>> fetchData() async {
    final zipCode = widget.zipCode;
    final countryCode = widget.countryCode;
    final apikey = "2b2cb860b44f4efeb998724d5f3a90ae";
    var token =
        "https://api.weatherbit.io/v2.0/forecast/daily?postal_code=${zipCode}&country=${countryCode}&days=5&key=${apikey}";

    final response = await http.get(Uri.parse(token));
    if (response.statusCode == 200) {
      var datajson = jsonDecode(response.body)["data"] as List;
      // print(datajson);
      List<WeatherData> temp =
          datajson.map((data) => WeatherData.fromJson(data)).toList();
      // print(temp);
      return temp;
    } else {
      throw Exception("Error loading request URL info.");
    }
  }

  @override
  void initState() {
    super.initState();
    dataobs = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forecast Data'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: dataobs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return DetailsCard(
                            date: snapshot.data[index].date,
                            humidity: snapshot.data[index].humidity,
                            temp: snapshot.data[index].maxTemp,
                            weather: snapshot.data[index].description,
                            wind: snapshot.data[index].windSpeed);
                      });
                } else if (snapshot.hasError) {
                  print(snapshot.hasError);
                  return Center(
                    child: Text(
                        "error:Check your Internet Connection   Or   ${snapshot.error}"),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}
