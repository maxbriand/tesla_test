import 'package:flutter/material.dart';
import 'package:tesla_gallery/infinite_scrollable_gallery.dart';

class TeslaGalleryPage extends StatefulWidget {
  const TeslaGalleryPage({super.key, required this.title});

  final String title;

  @override
  State<TeslaGalleryPage> createState() => _TeslaGalleryPageState();
}

class _TeslaGalleryPageState extends State<TeslaGalleryPage> {
  bool isModelY = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isModelY ? "Tesla Model Y" : "Tesla Model 3"),
        backgroundColor: Colors.grey[300],
      ),
      body: InfiniteScrollableGallery(isModelY: isModelY),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isModelY = !isModelY;
          });
        },
        backgroundColor: isModelY ? Colors.blue[600] : Colors.grey[300],
        foregroundColor: isModelY ? Colors.white : Colors.grey[600],
        child: Icon(isModelY ? Icons.toggle_on : Icons.toggle_off, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
