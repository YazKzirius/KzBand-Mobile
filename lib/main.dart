import 'package:flutter/material.dart';
import 'NavigationTabs/Devices.dart';
import 'NavigationTabs/Connected.dart';
import 'NavigationTabs/Analytics.dart';
import 'ColourTheme/KzBandTheme.dart';

void main() {
  runApp(const KzBandApp());
}

class KzBandApp extends StatefulWidget {
  const KzBandApp({super.key});

  @override
  State<KzBandApp> createState() => _KzBandAppState();
}

class _KzBandAppState extends State<KzBandApp> {
  int _index = 0;

  final pages = const [
    DevicesTab(),
    ConnectedTab(),
    AnalyticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: kzBandTheme,
      home: Scaffold(
        body: pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: const Color(0xFF060E13),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white38,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
            BottomNavigationBarItem(icon: Icon(Icons.bluetooth_connected), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
          ],
        ),
      ),
    );
  }
}
