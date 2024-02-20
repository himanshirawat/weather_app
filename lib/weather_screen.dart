import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather_add_card.dart';
import 'package:weather_app/weather_hourly_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather ;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = 'India';
      String countrycode = '';
      final result = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname,$countrycode&appid=10caf887de116872dbc0aa49c6d74d15'));
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw 'An unexpexted error occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }
  @override
  void initState() { 
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() { weather = getCurrentWeather();});
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp K',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64),
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Weather forecast',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final time = DateTime.parse(data['list'][index + 1]['dt_txt']);
                    return Hourlyforecast(
                      icon: data['list'][index + 1]['weather'][0]['main'] ==
                                  'Clouds' ||
                              data['list'][index + 1]['weather'][0]['main'] ==
                                  'Rain'
                          ? Icons.cloud
                          : Icons.sunny,
                      time: DateFormat.j().format(time),
                      num: data['list'][index + 1]['main']['temp'].toString(),
                      color: Colors.white,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const Text(
                'Additional Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    num: currentHumidity.toString(),
                  ),
                  CardItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    num: currentWindSpeed.toString(),
                  ),
                  CardItem(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    num: currentPressure.toString(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
        },
      ),
    );
  }
}
