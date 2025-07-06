import 'package:flutter/material.dart';
import 'widgets/search.dart';

import 'pages/connect.dart';
import 'pages/settingspage.dart';
import 'pages/results.dart';

import 'package:decent_flutter/widgets/title.dart';
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
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "decent-movies",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Builder(
                        builder: (context) {
                          return Bar(
                            onSubmitted: (query) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Results(
                                    query: query, 
                                    results: [ // MAKE THIS DYNAMIC ONCE WE GET THE BACKEND SETUP
                                      TitleWidget(
                                        name: "Amazing World of Gumball",
                                        imageUrl: "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTrT7oXKTplqRxYMZqclB1V4N0xJVSEU7zqBRdiU_tfu1BRhUrmUrnTnuWf66YQ8t_eEnaM-g",
                                        metadata: {
                                          "Year": "2023",
                                          "Type": "Movie",
                                          "Rating": "PG-13",
                                        },)
                                    ]
                                    ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
