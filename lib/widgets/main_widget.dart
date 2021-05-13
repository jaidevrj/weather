import 'package:flutter/material.dart';
import 'weather_tile.dart';
class MainWidget extends StatelessWidget {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final int humidity;
  final double windSpeed;

  MainWidget({
    @required this.location,
    @required this.temp,
    @required this.tempMin,
    @required this.tempMax,
    @required this.weather,
    @required this.humidity,
    @required this.windSpeed,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        Container(
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width,
          color: Color(0xfff1f1f1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${location.toString()}",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10.0,bottom:10.0),
                  child: Text(
                    "${((temp-32)*5/9).toInt().toString()}°C",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ),
                  Text(
                    "High of ${((tempMax-32)*5/9).toInt().toString()}°C - Low of ${((tempMin-32)*5/9).toInt().toString()}°C",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      ),
                  ),
          ],
          )
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
               WeatherTile(icon: Icons.thermostat_outlined, title: "Temperature", subtitle: "${((temp-32)*5/9).toInt().toString()}°C"),
               WeatherTile(icon: Icons.filter_drama_outlined, title: "Weather", subtitle: "${weather.toString()}"),
               WeatherTile(icon: Icons.wb_sunny, title: "Humidity", subtitle: "${humidity.toString()}%"),
               WeatherTile(icon: Icons.waves_outlined, title: "Wind Speed", subtitle: "${windSpeed.toInt().toString()} MPH"),
              ],
            ),
            ),
          )
        ],
        );
  }
}