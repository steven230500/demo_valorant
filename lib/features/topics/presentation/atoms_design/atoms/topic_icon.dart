import 'package:flutter/material.dart';

class TopicIcon extends StatelessWidget {
  final String url;

  const TopicIcon({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    // final String secureUrl = kIsWeb
    //     ? "https://corsproxy.io/?${Uri.encodeComponent(url)}"
    //     : url;
    final String secureUrl = url;

    return Image.network(
      secureUrl,
      width: 40,
      height: 40,
      errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
    );
  }
}
