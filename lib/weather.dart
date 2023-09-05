class Weather {
  String city;
  String description;
  double windSpeed;
  double temperature;
  int code;
  String icon;
  String date;

  Weather({
    required this.city,
    required this.description,
    required this.windSpeed,
    required this.temperature,
    required this.code,
    required this.icon,
    required this.date,
  });
  factory Weather.fromJson(Map<String, dynamic> json) {

    return Weather(
      city: json["name"],
      description: json['weather'][0]["main"],
      windSpeed: json['wind']["speed"],
      temperature: json["main"]["temp"],
      code: json["cod"],
      icon: json['weather'][0]["icon"],
      date: json["name"],

    );
  }
  
}
