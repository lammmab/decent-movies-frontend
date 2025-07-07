import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  final String query;
  final List results;

  const Results({super.key, required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Widget>> groupedResults = {};

    for (var pluginResult in results) {
      groupedResults.putIfAbsent(pluginResult.pluginName, () => []);
      groupedResults[pluginResult.pluginName]!.add(pluginResult.title);
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: Text(
          'Results for "$query"',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: groupedResults.entries.map((entry) {
            final pluginName = entry.key;
            final pluginWidgets = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pluginName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pluginWidgets.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (context, index) {
                    return pluginWidgets[index];
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}