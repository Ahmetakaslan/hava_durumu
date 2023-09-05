import 'dart:convert';

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:hava_durumu_kurs/constants.dart';
import 'package:hava_durumu_kurs/weather.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:hava_durumu_kurs/search_page.dart';

import 'dailyWidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String picture = "assets/dark.jpg";
  double? windSpeed;
  String city = "london";
  String? description;
  double? temperature;
  Position? position;
  String? icon;
  final String api = "d97eddb462a8d6008c91e048083942c2";
  // ignore: prefer_typing_uninitialized_variables
  var response;
  Weather? weather;
  String? lat="41.0122";
  String? lon="28.976";

  List<String> icons = [];
  List<double> temperatures = [];
  List<String> dates = [];

  /// Device Position
  Future<void> getDevicePossition() async {
    try {
      print("came getDevicePossition");
      print("possiton first =>${position}");
      await _determinePosition();
      position = await _determinePosition();
      print("${position}");
      if(position==null){
        
       lat="41.0082";
        lon="28.9784";
      }else{
         setState(() {
        lat = position!.latitude.toString() as String?;
        lon = position!.longitude.toString() as String?;
      });
      }
     

      debugPrint("out getDevicePossition");
    } catch (e) {
      print("error in getDevicePossition => $e");
    }
  }

// Data from location
  Future<void> getDataFromLocation() async {
    try {
      response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$api&units=metric&lang=tr'));
      weather = await Weather.fromJson(
        jsonDecode(response.body),
      );
      backPhoto();

      print("Durum ne : ${weather!.description}");
      setState(() {
        city = weather!.city;
        temperature = weather?.temperature;
        description = weather!.description;
        windSpeed = weather!.windSpeed;
        icon = weather!.icon;
      });
    } catch (e) {
      print("error  in getDataFromLocation => $e ");
    }
  }

  Future<void> getDataFiveDayFromLocation() async {
    try {
      print("came getDataFiveDayFromLocation");
      response = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$api&lang=tr&units=metric"),
      );
      print("now in getDataFiveDayFromLocation ");
      var a = jsonDecode(response.body);
      temperatures.clear();
      icons.clear();
      dates.clear();
      setState(() {
        for (int i = 7; i < 40; i += 8) {
          temperatures.add(a["list"][i]["main"]["temp"]);
          icons.add(a["list"][i]["weather"][0]["icon"]);
          dates.add(a["list"][i]["dt_txt"]);
        }
      });

      print("temperatures=> $temperatures");
      print("icons=> $icons");
      print("dates=> $dates");
      print("out getDataFiveDayFromLocation");
    } catch (e) {
      print("exception! in getDataFiveDayFromLocation mehod=> ${e}");
    }
  }
//

//Data from name
  Future<void> getDataWithName() async {
    try {
      response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api&units=metric&lang=tr'),
      );

      weather = await Weather.fromJson(
        jsonDecode(response.body),
      );
      backPhoto();
      setState(() {
        city = weather!.city;
        temperature = weather?.temperature;
        description = weather!.description;
        windSpeed = weather!.windSpeed;
        icon = weather!.icon;
      });
    } catch (e) {
      print("error in getData =>$e ");
    }
  }

  Future<void> getDataFiveDayWithName() async {
    print("in getDataFiveDayWithName ");
    response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$api&units=metric&lang=tr"),
    );
    print("now in getDataFiveDay ");
    var a = jsonDecode(response.body);
    temperatures.clear();
    icons.clear();
    dates.clear();
    
      for (int i = 7; i < 40; i += 8) {
        temperatures.add(a["list"][i]["main"]["temp"]);
        icons.add(a["list"][i]["weather"][0]["icon"]);
        dates.add(a["list"][i]["dt_txt"]);
      }
  

    print("temperatures=> after search $temperatures");
    print("icons=> after search $icons");

    print("dates=> after search $dates");

    print("out  getDataFiveDayWithName");
  }

  void allMethod() async {
    try {
      print("in All Data ");
      await getDevicePossition();
      print("We are waiting for getDataWithName");
      await getDataFiveDayFromLocation();
      await getDataFromLocation();
    } catch (e) {
      print("excepion! error all method $e");
    }
  }

  void backPhoto() {
    print("in backPhoto switch case");
    switch (weather!.description) {
      case "Thunderstorm":
        weather!.description = "Fırtına";
        picture = "assets/storm.jpg";
      case "Drizzle":
        weather!.description = "Hafif Yağmur";
        picture = "assets/rain.jpg";
      case "Rain":
        weather!.description = "Yağmur";
        picture = "assets/rain.jpg";
      case "Snow":
        weather!.description = "Kar";
        picture = "assets/snow.jpg";
      case "Mist":
        weather!.description = "Sis";
        picture = "assets/sis.jpg";
      case "Clouds":
        picture = "assets/clouds.jpg";
        weather!.description = "Bulutlu";

      case "Clear":
        weather!.description = "Açık";
        picture = "assets/sunny.jpg";
      default:
        picture = "assets/back.jpg";
    }
    print("out backPhoto switch case");

    setState(() {});
  }

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    allMethod();
  }

  @override
  Widget build(BuildContext context) {
    return myBackContainer(context);
  }

  Container myBackContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("${picture}"),
        ),
      ),
      child: (  temperature == null)
          ? Center(
              child: CircularSeekBar(
              width: double.infinity,
              height: 250,
              progress: 100,
              barWidth: 8,
              startAngle: 45,
              sweepAngle: 270,
              strokeCap: StrokeCap.butt,
              progressGradientColors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple
              ],
              innerThumbRadius: 5,
              innerThumbStrokeWidth: 3,
              innerThumbColor: Colors.white,
              outerThumbRadius: 5,
              outerThumbStrokeWidth: 10,
              outerThumbColor: Colors.blueAccent,
              dashWidth: 1,
              dashGap: 2,
              animation: true,
              valueNotifier: _valueNotifier,
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: _valueNotifier,
                    
                    builder: (_, double value, __) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${value.round()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )),
              ),
            ))
          : MyScaffold(context));
  }

  Scaffold MyScaffold(BuildContext context) {
    return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.network(
                          "https://openweathermap.org/img/wn/$icon@4x.png"),
                    ),
                    myRow("İl: ", "${weather!.city}"),
                    myRow("Sıcaklık: ", "${weather!.temperature}"),
                    myRow("Açıklama: ", "${weather!.description}"),
                    myRow("Rüzgar Hızı: ", "${weather!.windSpeed}"),
                    IconButton(
                      onPressed: () async {
                        city = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                        print("City name after searchPage=>" + city);
                        setState(() {});
                        await getDataFiveDayWithName();
                        await getDataWithName();

                        print("after all");
                      },
                      icon: Icon(
                        Icons.search,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    buidCard()
                  ],
                ),
              ),
            );
  }

  Widget buidCard() {
    List<DailyWidgetCard> cards = [];
    print("temperatures before buildCard $temperatures");
    print("dates before buildCard $dates");

    for (int i = 0; i < 5; i++) {
      cards.add(
        DailyWidgetCard(
          temperature: temperatures[i],
          date: dates[i],
          icon: icons[i],
          picture: picture,
        ),
      );
    }
    print("now in buildCard ");
    print("temperatures=> in build card $temperatures");
    print("icons=> in build card $icons");

    print("dates=> in build card $dates");

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: cards),
    );
  }

  Padding myRow(String first, String second) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                child: Text("$first",
                    style: weather!.description == "Yağmur"
                        ? textStyledForDarkPhoto
                        : textStyleKey),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Text(
                "$second",
                style: textStyleValue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    print("now we are in _determinePosition");
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("we out _determinePosition with first return");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print("we out _determinePosition with second return");

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("we out _determinePosition with third return");

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print(
        "we out _determinePosition with end return and we get it getCurrentPosition  ");

    return await Geolocator.getCurrentPosition();
  }
}
