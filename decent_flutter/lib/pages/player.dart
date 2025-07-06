import 'package:flutter/material.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'dart:io';



class PlayerPage extends StatelessWidget {
  final String videoUrl;

  const PlayerPage({super.key, required this.videoUrl});

  bool isMobile() {
    return !(Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  }

  Widget _buildMobilePlayer() {
    return Scaffold(
      body: BetterPlayer.network(
        videoUrl,
        betterPlayerConfiguration: BetterPlayerConfiguration(
          autoPlay: true,
          fit: BoxFit.contain,
          errorBuilder: (context, error) {
            return Center(
              child: Text("Error loading video:\n$error"),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopPlayer() {
    return Scaffold(
          appBar: AppBar(title: const Text('Desktop Video Player')),
          body: const Center(child: Text("Desktop player coming soon")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMobile()) {
      return _buildMobilePlayer();
    } else {
      return _buildDesktopPlayer();
    }
  }
}

