import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:salah_times/widgets/modern_prayer_card.dart';

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
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(child: ModernPrayerCard(prayerTimes: prayerTimes)),
      ),
    );
  }
}
