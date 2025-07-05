import 'package:flutter/material.dart';
import 'widgets/search.dart';

import 'pages/connect.dart';
import 'pages/settingspage.dart';

import 'widgets/settings.dart';
void main() {
  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39), 
        body: Stack(
          children: [
            Builder(
              builder: (context) {
                return SettingsButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                );
              },
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "decent-movies",
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Bar(),
                    ],
                  ),
                ),
              ),
            ),

            // Center(
            //   child: ConnectPage(),
            // ),
          ],
          
        ),
      ),
    );
  }
}
