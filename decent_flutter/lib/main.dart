import 'utils/save.dart';
import 'package:flutter/material.dart';
import 'widgets/search.dart';

import 'pages/connect.dart';
import 'pages/settingspage.dart';
import 'pages/results.dart';

import 'widgets/title.dart';
import 'widgets/settings.dart';

import 'utils/http.dart';

void main() {
  runApp(const MainApp());
}

class PluginResult {
  final String pluginName;
  final TitleWidget title;

  PluginResult({required this.pluginName, required this.title});
}

Future<List<PluginResult>> getResults(String query) async {
  final httpClient = Http();
  final saveData = await getData();
  final token = saveData.token;
  final backendUrl = saveData.backendUrl;
  final url = '$backendUrl/api/search';

  Map<String, dynamic> postResponse;
  try {
    postResponse = await httpClient.post(
      url,
      body: {
        'token': token,
        'query': query,
      },
    );
  } catch (e) {
    print('Error fetching results: $e');
    return [];
  }

  final List<dynamic> resultsJson = postResponse['results'] ?? [];

  final List<PluginResult> pluginResults = resultsJson.map((item) {
    final mapItem = item as Map<String, dynamic>;
    final pluginName = mapItem['pluginName'] as String? ?? 'Unknown';
    final titleJson = mapItem['result'] as Map<String, dynamic>;

    return PluginResult(
      pluginName: pluginName,
      title: TitleWidget.fromJson({
        ...titleJson,
        'pluginName': pluginName,
      }),
    );
  }).toList();

  return pluginResults;
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool showConnect = true;

  void hideConnectPage() {
    setState(() {
      showConnect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 39, 39, 39),
        body: Stack(
          children: [
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
                            onSubmitted: (query) async {
                              final results = await getResults(query);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Results(
                                    query: query,
                                    results: results,
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
            Positioned(
              top: 24,
              right: 24,
              child: Builder(
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
            ),
            if (showConnect)
              ConnectPage(
                onConnected: hideConnectPage,
              ),
          ],
        ),
      ),
    );
  }

}
