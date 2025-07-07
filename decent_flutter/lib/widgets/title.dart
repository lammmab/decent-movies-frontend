import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import '../utils/http.dart';
import '../utils/save.dart';
import '../pages/titlepage.dart';
class TitleWidget extends StatefulWidget {
  final String name;
  final String? imageUrl;
  final Map<String, String>? metadata;
  final String plugin;

  const TitleWidget({ 
    Key? key,
    required this.name,
    this.imageUrl,
    this.metadata,
    required this.plugin, 
  }) : super(key: key);

  factory TitleWidget.fromJson(Map<String, dynamic> json) {
    return TitleWidget(
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, String>.from(
              (json['metadata'] as Map).map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              ),
            )
          : null,
      plugin: json['pluginName'] ?? '', 
    );
  }

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  bool _hovering = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double tileWidth = constraints.maxWidth;
      final double tileHeight = constraints.maxHeight;

      final double scale = (tileWidth / 200).clamp(0.7, 1.2);

      final double imageWidth = tileWidth;
      final double imageHeight = tileHeight;
      final double titleFontSize = (16 * scale).clamp(12.0, 20.0);
      final double metadataFontSize = (12 * scale).clamp(10.0, 16.0);

      final double scaleFactor = (_hovering || _focused) ? 1.05 : 1.0;

      return FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (hovering) => setState(() {
          _hovering = hovering;
        }),
        onShowFocusHighlight: (focused) => setState(() {
          _focused = focused;
        }),
        child: InkWell(
          onTap: () async {
            final httpClient = Http();
            final saveData = await getData();
            final token = saveData.token;
            final backendUrl = saveData.backendUrl;

            try {
              final postResponse = await httpClient.post(
                "$backendUrl/api/getTitleInfo",
                body: { 'token': token, 'plugin': widget.plugin, 'title': widget.name },
              );
              if (!mounted) return;
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TitleDetailsPage(
                      details: postResponse['details'],
                      name: widget.name,
                      plugin: widget.plugin,
                    ),
                  ),
                );
            } catch (e) {
              print("There was an error");
            }
          },
          child: Transform.scale(
            scale: scaleFactor,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8 * scale),
                  child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.imageUrl!,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _placeholderImage(imageWidth, imageHeight, scale),
                        )
                      : _placeholderImage(imageWidth, imageHeight, scale),
                ),
                Positioned(
                  bottom: 10 * scale,
                  left: 8 * scale,
                  right: 8 * scale,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StrokeText(
                        text: widget.name,
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
                      if (widget.metadata != null && widget.metadata!.isNotEmpty)
                        ...[
                          SizedBox(height: 4 * scale),
                          ...widget.metadata!.entries.map((entry) {
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
            ),
          ),
        ),
      );
    });
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
