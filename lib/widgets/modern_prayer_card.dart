import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModernPrayerCard extends StatelessWidget {
  final PrayerTimes prayerTimes;

  const ModernPrayerCard({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    // Helper to format DateTime to "05:30 PM"
    String formatTime(DateTime time) => DateFormat.jm().format(time);

    // Identify which prayer is active to highlight it
    final current = prayerTimes.currentPrayer();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3C72), // Modern deep blue
            const Color(0xFF2A5298),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const Divider(color: Colors.white24, height: 32),
          _buildPrayerRow("Fajr", prayerTimes.fajr, Icons.wb_twilight, current == Prayer.fajr),
          _buildPrayerRow("Dhuhr", prayerTimes.dhuhr, Icons.wb_sunny, current == Prayer.dhuhr),
          _buildPrayerRow("Asr", prayerTimes.asr, Icons.wb_sunny_outlined, current == Prayer.asr),
          _buildPrayerRow("Maghrib", prayerTimes.maghrib, Icons.dark_mode_outlined, current == Prayer.maghrib),
          _buildPrayerRow("Isha", prayerTimes.isha, Icons.nightlight_round, current == Prayer.isha),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              DateFormat('EEEE, MMM d').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Icon(Icons.location_on, color: Colors.white70),
      ],
    );
  }

  Widget _buildPrayerRow(String name, DateTime time, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.amber : Colors.white60, size: 20),
          const SizedBox(width: 16),
          Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            DateFormat.jm().format(time),
            style: TextStyle(
              color: isActive ? Colors.amber : Colors.white,
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
