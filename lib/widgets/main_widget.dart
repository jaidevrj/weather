import 'package:flutter/material.dart';
import '../details.dart';
import 'weather_tile.dart';
import '../forecast.dart';

class MainWidget extends StatelessWidget {
  final String location;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String weather;
  final double humidity;
  final double windSpeed;
  final String zipCode;
  final String countryCode;

  MainWidget(
      {@required this.location,
      @required this.temp,
      @required this.tempMin,
      @required this.tempMax,
      @required this.weather,
      @required this.humidity,
      @required this.windSpeed,
      @required this.zipCode,
      @required this.countryCode});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3,
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
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  "${((temp - 32) * 5 / 9).toInt().toString()}°C",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                "High of ${((tempMax - 32) * 5 / 9).toInt().toString()}°C - Low of ${((tempMin - 32) * 5 / 9).toInt().toString()}°C",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForcastScreen(
                            zipCode: zipCode, countryCode: countryCode)))
              },
              child: Text(
                '5-Day Forecast',
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor: MaterialStateProperty.all(Color(0xfff1f1f1)),
                  textStyle: MaterialStateProperty.all(TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400))),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView(
                children: [
                  WeatherTile(
                      icon: Icons.thermostat_outlined,
                      title: "Temperature",
                      subtitle:
                          "${((temp - 32) * 5 / 9).toInt().toString()}°C"),
                  WeatherTile(
                      icon: Icons.filter_drama_outlined,
                      title: "Weather",
                      subtitle: "${weather.toString()}"),
                  WeatherTile(
                      icon: Icons.wb_sunny,
                      title: "Humidity",
                      subtitle: "${humidity.toInt().toString()}%"),
                  WeatherTile(
                      icon: Icons.waves_outlined,
                      title: "Wind Speed",
                      subtitle: "${windSpeed.toInt().toString()} MPH"),
                ],
              ),
            ),
          ),
        ),
        TextButton(
          // style: ButtonStyle(backgroundColor:),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Details()));
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
}
