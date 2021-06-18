import 'package:flutter/material.dart';

import 'detailsItem.dart';

class DetailsCard extends StatelessWidget {
  String date;
  double temp;
  double wind;
  double humidity;
  String weather;

  DetailsCard(
      {@required this.date,
      @required this.humidity,
      @required this.temp,
      @required this.weather,
      @required this.wind});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  date,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DetailsItem(
                                icon: Icons.thermostat_outlined,
                                subtitle: 'Temp',
                                title: '${temp.toInt().toString()}°C'),
                            DetailsItem(
                                icon: Icons.wb_sunny,
                                subtitle: 'Humidity',
                                title: '${humidity.toInt().toString()}%'),
                            DetailsItem(
                                icon: Icons.waves_outlined,
                                subtitle: 'Wind',
                                title: '${wind.toInt().toString()} MPH'),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.filter_drama_outlined,
                              color: Colors.purple,
                              size: 35,
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: Text(
                                weather,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 18),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
