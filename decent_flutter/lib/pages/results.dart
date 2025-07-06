import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  final String query;
  final List results;

  const Results({super.key, required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: results.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2 / 3,
            ), 
          itemBuilder: (context,index) {
            final result = results[index];
            return result;
          },
          )
      )
    );
  }
}