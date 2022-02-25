import 'dart:ui';

import 'package:clima/screens/city_screen.dart';
import 'package:clima/services/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;

  const LocationScreen({Key? key, this.locationWeather}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int? temperature;
  int? condition;
  String? cityName;
  WeatherModel weather = WeatherModel();
  String? weatherIcon;
  String? weatherMessage;
  @override
  void initState() {
    super.initState();
    upDateId(widget.locationWeather);
  }

  upDateId(weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherMessage = "unable to get weather data";
        weatherIcon = "Error";
        return;
      }
      double temp = weatherData["main"]["temp"];
      temperature = temp.toInt();
      weatherMessage = weather.getMessage(temperature!);
      weatherIcon = weather.getWeatherIcon(weatherData["weather"][0]["id"]);
      cityName = weatherData["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //     Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () async {
                        var weatherData = await weather.getLocationWeather();
                        upDateId(weatherData);
                      },
                      child: const Icon(
                        Icons.near_me,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CityScreen()));
                        if (typedName != null) {
                          var weatherData =
                              await weather.getWeatherData(typedName);
                          upDateId(weatherData);
                        }
                      },
                      child: const Icon(
                        Icons.location_city,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      "$weatherIcon",
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0, right: 15),
                child: Text(
                  "$weatherMessage ",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
