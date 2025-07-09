import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/http.dart';
import '../utils/save.dart';
import '../player/webview.dart';
class StaticTitleImage extends StatelessWidget {
  final String? imageUrl;
  final bool blur;

  const StaticTitleImage({
    Key? key,
    this.imageUrl,
    this.blur = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _placeholderImage(),
          )
        : _placeholderImage();

    if (!blur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey[400],
      child: const Icon(
        Icons.movie_outlined,
        size: 60,
        color: Colors.white70,
      ),
    );
  }
}


class TitleDetailsPage extends StatefulWidget {
  final Map<String, dynamic> details;
  final String name;
  final String plugin;
  const TitleDetailsPage({Key? key, required this.details, required this.name, required this.plugin}) : super(key: key);

  @override
  State<TitleDetailsPage> createState() => _TitleDetailsPageState();
}

class _TitleDetailsPageState extends State<TitleDetailsPage> {

@override
Widget build(BuildContext context) {
  final imageUrl = widget.details['image'] as String?;
  final metadataList = widget.details['metadata'] as List<dynamic>? ?? [];

  final double left = 16;
  final double top = 16;


  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final double maxWidth = screenWidth * 0.45;
  final double heightFromWidth = maxWidth * 3 / 2;
  final double maxHeight = screenHeight * 0.8;

  double smallImageWidth = maxWidth;
  double smallImageHeight = heightFromWidth;

  if (heightFromWidth > maxHeight) {
    smallImageHeight = maxHeight;
    smallImageWidth = maxHeight * 2 / 3;
  }

  const double horizontalPadding = 12;

  return Scaffold(
  backgroundColor: const Color.fromARGB(255, 39, 39, 39),
  appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 30, 30, 30),
    title: Text(
      widget.details['isMovie'] == true ? 'Movie Details' : 'Show Details',
      style: const TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  body: Stack(
    children: [
      Positioned.fill(
        child: StaticTitleImage(
          imageUrl: imageUrl,
          blur: true,
        ),
      ),
      Positioned(
        top: top,
        left: left,
        width: smallImageWidth,
        height: smallImageHeight,
        child: StaticTitleImage(
          imageUrl: imageUrl,
          blur: false,
        ),
      ),
      Positioned(
        top: top,
        left: left + smallImageWidth + horizontalPadding,
        right: 16,
        height: smallImageHeight + 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 4,
                    color: Colors.black87,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: metadataList.map<Widget>((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        entry.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          shadows: [
                            Shadow(
                              blurRadius: 3,
                              color: Colors.black87,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 172, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                ),
                onPressed: () async {
                  final httpClient = Http();
                  final saveData = await getData();
                  final token = saveData.token;
                  final backendUrl = saveData.backendUrl;
                  final url = '$backendUrl/api/getEpisode';
                  // later, this will attempt to grab last-known data about play-time, episode, and season. for now it will either play the first season/episode, or the movie.
                  if (widget.details['isMovie']) {
                    final response = await httpClient.post(
                      url,
                      body: {
                        'token': token,
                        'plugin': widget.plugin,
                        'title': widget.name,
                        's': '0',
                        'e': '0'
                      },
                    );
                    print(response);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyBrowser(
                          title: response['episode']['servers']['servers']['default']['url'],
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Play',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

}


}