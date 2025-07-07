import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class Progress {
  final String movieName;
  final int seasonNumber;
  final int episodeNumber;

  final double timeWatched;

  Progress({ required this.movieName, required this.episodeNumber, required this.timeWatched, required this.seasonNumber }); 

  Map<String, dynamic> toJson() => {
    'movieName': movieName,
    'seasonNumber': seasonNumber,
    'episodeNumber': episodeNumber,
    'timeWatched': timeWatched,
  };

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    movieName: json['movieName'],
    seasonNumber: json['seasonNumber'],
    episodeNumber: json['episodeNumber'],
    timeWatched: (json['timeWatched'] as num).toDouble(),
  );
}

class SaveData {
  final String token;
  final String backendUrl;
  final List<Progress>? savedProgress;

  SaveData({required this.token, required this.backendUrl, this.savedProgress});

  String normalizeTitle(String title) {
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String getProgressFromName(String name) {
    String normalizedInput = normalizeTitle(name);
    return normalizedInput;
  } // update this later as it will not work out of the box for now once we have our backend setup we will come back
}

Future<void> saveData(SaveData saveData) async {
  final prefs = await SharedPreferences.getInstance();

  final jsonString = jsonEncode(
    saveData.savedProgress?.map((e) => e.toJson()).toList() ?? []
  );
  
  await prefs.setString('savedProgress', jsonString);
  await prefs.setString('token', saveData.token);
  await prefs.setString('backendUrl', saveData.backendUrl);
  
}

Future<List<Progress>> loadProgressListFromString(jsonString) async {
  final List<dynamic> decoded = jsonDecode(jsonString);

  return decoded.map((item) => Progress.fromJson(item)).toList();
}

Future<SaveData> getData() async {
  final prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('token') ?? '';
  String? backendUrl = prefs.getString('backendUrl') ?? '';
  String? progress = prefs.getString('savedProgress') ?? '';

  List<Progress> progressList = await loadProgressListFromString(progress);

  return SaveData(token: token, backendUrl: backendUrl, savedProgress: progressList);

}