import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

class TitleWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Map<String, String>? metadata;

  const TitleWidget({
    Key? key,
    required this.name,
    this.imageUrl,
    this.metadata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
    builder: (context, constraints) {
      final double tileWidth = constraints.maxWidth;
      final double tileHeight = constraints.maxHeight;

      final double scale = (tileWidth / 200).clamp(0.7, 1.2);

      final double imageWidth = tileWidth;
      final double imageHeight = tileHeight;
      final double titleFontSize = (16 * scale).clamp(12.0, 20.0);
      final double metadataFontSize = (12 * scale).clamp(10.0, 16.0);

      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8 * scale),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholderImage(imageWidth, imageHeight, scale),
                  )
                : _placeholderImage(imageWidth, imageHeight, scale),
          ),
          Positioned(
            top: 8 * scale,
            left: 8 * scale,
            right: 8 * scale,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                StrokeText(
                  text: name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  strokeColor: Colors.black,
                  textStyle: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black87,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                if (metadata != null && metadata!.isNotEmpty) ...[
                  SizedBox(height: 4 * scale),
                  ...metadata!.entries.map((entry) {
                    return StrokeText(
                      text: '${entry.key}: ${entry.value}',
                      textAlign: TextAlign.center,
                      strokeColor: Colors.black,
                      textStyle: TextStyle(
                        fontSize: metadataFontSize,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            blurRadius: 3,
                            color: Colors.black87,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      );
    },
  );
  }

  Widget _placeholderImage(double width, double height, double scale) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[400],
      child: Icon(
        Icons.movie_outlined,
        size: 60 * scale,
        color: Colors.white70,
      ),
    );
  }
}
