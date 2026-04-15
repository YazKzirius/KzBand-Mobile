import 'package:flutter/material.dart';
import 'package:kzband/NavigationTabs/Devices.dart';
import 'package:kzband/NavigationTabs/Connected.dart';
import 'package:kzband/NavigationTabs/Analytics.dart';
import 'package:kzband/ColourTheme/KzBandTheme.dart';

void main() {
  runApp(const KzBandApp());
}

class KzBandApp extends StatefulWidget {
  const KzBandApp({super.key});

  @override
  State<KzBandApp> createState() => _KzBandAppState();
}

class _KzBandAppState extends State<KzBandApp> {
  int index = 0;

  final pages = const [
    DevicesTab(),
    ConnectedTab(),
    AnalyticsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: KzBandTheme.background,
      ),
      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          backgroundColor: KzBandTheme.background,
          selectedItemColor: KzBandTheme.accent,
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
