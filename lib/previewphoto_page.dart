import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A widget that displays the picture taken by the user.
class PreviewPictureScreen extends StatelessWidget {
  final Uint8List imgBytes;

  const PreviewPictureScreen({super.key, required this.imgBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: Center(
            child: InteractiveViewer(
          maxScale: 5,
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.memory(imgBytes)),
        )));
  }
}
