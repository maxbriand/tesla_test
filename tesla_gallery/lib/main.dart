import 'package:flutter/material.dart';
import 'package:tesla_gallery/tesla_gallery_page.dart';

void main() {
  runApp(const MyApp());
}

// The many entry point will launch the Testa Gallery Page as home screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tesla Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TeslaGalleryPage(title: 'Tesla Gallery'),
      debugShowCheckedModeBanner: false,
    );
  }
}
