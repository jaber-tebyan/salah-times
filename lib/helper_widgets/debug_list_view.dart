import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salah_times/db_helper.dart';

class StringListDisplay extends StatefulWidget {
  final CitiesDatabase db;
  const StringListDisplay({super.key, required this.db});
  void toastPrayerTimes(
    BuildContext context,
    String country,
    String city,
  ) async {
    print("${country}, ${city}");
    Coordinate? c = await db.getCoordinate(
      countryName: country,
      cityName: city,
    );
		if(!context.mounted) return;
    if (c == null) {
      print("No coordinates found");
    }
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(Coordinates(c!.lat, c.lng), params);
    showPrayerTimes(context, prayerTimes);
  }

  void showPrayerTimes(BuildContext context, PrayerTimes prayerTimes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Prayer Times"),
          content: Text('''
					fajr: ${prayerTimes.fajr}
					dhuhr: ${prayerTimes.dhuhr}
					asr: ${prayerTimes.asr}
					maghrib: ${prayerTimes.maghrib}
					isha: ${prayerTimes.isha}
					'''),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // ignore: use_build_context_synchronously
  }

  @override
  State<StatefulWidget> createState() {
    return _StringListDisplayState();
  }
}

class _StringListDisplayState extends State<StringListDisplay> {
  String? selectedCountry;
  String? selectedCity;
  @override
  Widget build(BuildContext context) {
    // If the list is empty, show a placeholder
    if (selectedCountry == null) {
      return FutureBuilder<List<String>?>(
        future: widget.db.getCountries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            final countries = snapshot.data!;
            return ListView.builder(
              itemCount: countries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(countries[index]),
                  onTap: () {
                    setState(() {
                      selectedCountry = countries[index];
                    });
                  },
                );
              },
            );
          }
          return const Center(child: Text('No countries available'));
        },
      );
    }
    return FutureBuilder<List<String>?>(
      future: widget.db.getCities(selectedCountry),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          final cities = snapshot.data!;
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(cities[index]),
                onTap: () {
                  selectedCity = cities[index];
                  widget.toastPrayerTimes(
                    context,
                    selectedCountry!,
                    selectedCity!,
                  );
                  selectedCity = null;
                  selectedCountry = null;
                  setState(() {});
                },
              );
            },
          );
        }
        return const Center(child: Text('No cities available'));
      },
    );
  }
}
