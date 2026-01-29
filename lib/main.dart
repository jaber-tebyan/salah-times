import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:salah_times/db_helper.dart';
import 'package:salah_times/widgets/modern_prayer_card.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  CitiesDatabase db = CitiesDatabase();
  await db.init();
  Coordinate? c = await db.getCoordinate(
    countryName: "Turkey",
    cityName: "Kocaeli",
  );

  final kartepeCoordinates = Coordinates(40.745, 30.011);
  final Coordinates kocaeliCoordinates;
  if (c != null) {
    kocaeliCoordinates = Coordinates(c.lat, c.lng);
  } else {
    kocaeliCoordinates = kartepeCoordinates;
  }
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
