import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Api key
  final _weatherService = WeatherService('dd7213d23a6f6d61b75d2d248ec0caef');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for thr city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any error

    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/Sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/sunnyandrainy.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/Sunny.json';
      default:
        return 'assets/Sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    //fetch weather

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/Weather.jpg'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 58, 129, 186),
          title: const Text(
            'Weather App',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: const Color.fromARGB(255, 252, 252, 252).withOpacity(0.2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //city Name
                  Text(
                    _weather?.cityName ?? "Loading City....",
                    style: TextStyle(fontSize: 20),
                  ),

                  //animation
                  Lottie.asset(
                      getWeatherAnimation(_weather?.mainCondition ?? "")),
                  //city Temperature
                  Text(
                    'Temperature ${_weather?.temperature.round()}°C',
                    style: const TextStyle(fontSize: 20),
                  ),

                  // weather condition
                  Text(
                    _weather?.mainCondition ?? "",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 58, 129, 186),
            fixedColor: Color.fromARGB(255, 255, 255, 255),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 238, 239, 239),
                    size: 40.0,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.location_disabled_outlined,
                    color: Color.fromARGB(255, 246, 246, 244),
                  ),
                  label: 'My Location'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history,
                      color: Color.fromARGB(255, 245, 244, 241)),
                  label: 'Activity')
            ]),
      ),
    );
  }
}
