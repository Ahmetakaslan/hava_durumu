import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hava_durumu_kurs/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:hava_durumu_kurs/constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String api = "d97eddb462a8d6008c91e048083942c2";
  String? city;
  

  Future<void> getData() async {
    var response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api&units=metric&lang=tr'),
    );
    print("/////////////////////// ${jsonDecode(response.body)}");
    print("************************** ${jsonDecode(response.body)["cod"]}");
    print(city);
    if (response.statusCode == 404) {
      print("code hatalı");
      SnackBar snackBar = SnackBar(
        elevation: 0,
        duration: Duration(seconds: 1),
        backgroundColor: Colors.transparent,
        content: Container(
          child: Center(
            child: Text(
              "Lütfen geçerli isim giriniz",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {

      Control();
    }
  }

  void Control() {
    if (sehirController.text == "") {
      SnackBar snackBar = SnackBar(
          elevation: 0,
          duration: Duration(seconds: 1),
          backgroundColor: Colors.transparent,
          content: Container(
            child: Center(  
              child: Text(
                "Lütfen geçerli isim giriniz",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Navigator.pop(context, sehirController.text);
    }
  }

  String picture = "assets/back_black.jpg";
  TextEditingController sehirController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("${picture}"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      city = sehirController.text;
                      getData();
                 
                    });
                  },
                  autofocus: true,
                  style: TextStyle(fontSize: 25),
                  controller: sehirController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            city = sehirController.text;
                            getData();
                          });
                        },
                      ),
                      border: InputBorder.none,
                      hintText: "Şehir ismi giriniz",
                      hintStyle: TextStyle(fontSize: 25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
