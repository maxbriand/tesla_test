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
      floatingActionButton: IconButton(
        onPressed: () {
          setState(() {
            isModelY = !isModelY;
          });
        },
        icon: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              isModelY ? Icons.toggle_off : Icons.toggle_on,
              size: 80,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 2),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ),
              ],  
            ),
            Icon(
              isModelY ? Icons.toggle_on : Icons.toggle_off,
              size: 80,
              color: isModelY ? Colors.blue[600] : Colors.grey[600],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
