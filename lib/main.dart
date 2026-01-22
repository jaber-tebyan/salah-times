import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

void main() {
  final kocaeliCoordinates = Coordinates(40.7625, 29.9175);
  final params = CalculationMethod.muslim_world_league.getParameters();
  params.madhab = Madhab.shafi;
  final prayerTimes = PrayerTimes.today(kocaeliCoordinates, params);
  runApp(MainApp(prayerTimes: prayerTimes));
}

class MainApp extends StatelessWidget {
  final PrayerTimes prayerTimes;
  const MainApp({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: PrayerTimesWidget(prayerTimes: prayerTimes)),
      ),
    );
  }
}

class PrayerTimesWidget extends StatelessWidget {
  final PrayerTimes prayerTimes;
  const PrayerTimesWidget({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Prayer Times"),
        Text("Fajr Prayer: ${prayerTimes.fajr}"),
        Text("Duhr Prayer: ${prayerTimes.dhuhr}"),
        Text("Asr Prayer: ${prayerTimes.asr}"),
        Text("Maghrib Prayer: ${prayerTimes.maghrib}"),
        Text("Isha Prayer: ${prayerTimes.isha}"),
      ],
    );
  }
}
