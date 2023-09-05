import 'package:flutter/material.dart';

import 'package:hava_durumu_kurs/constants.dart';
import 'package:hava_durumu_kurs/weather.dart';

import 'cliperClass.dart';

class DailyWidgetCard extends StatelessWidget {
  String icon;
  double temperature;
  String date;
  String picture;
  DailyWidgetCard({
    Key? key,
    required this.icon,
    required this.temperature,
    required this.date,
    required this.picture,
  }) : super(key: key);

  String Convert() {
    List<String> days = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    DateTime dates = DateTime.parse(date);
    return days[dates.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          width: 120,
          child: Card(
            elevation: 2,
            color: Colors.transparent,
            child: SizedBox(
                child: Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                      "https://openweathermap.org/img/wn/$icon@2x.png"),
                ),
                Text("${temperature.round()} °C",
                    style: textStyledForWithePhoto),
                Text(
                  "${Convert()}",
                  style: textStyleSmall,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
