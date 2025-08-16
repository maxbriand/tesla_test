import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tesla_gallery/infinite_scrollable_gallery.dart';

class TeslaGalleryPage extends StatefulWidget {
  const TeslaGalleryPage({super.key, required this.title});

  final String title;

  @override
  State<TeslaGalleryPage> createState() => _TeslaGalleryPageState();
}

class _TeslaGalleryPageState extends State<TeslaGalleryPage> {
  bool isModelY = false;

  Future<List<String>> getImagesFromUnsplash() async {
    final options = BaseOptions(
      baseUrl: 'https://api.unsplash.com',
      headers: {
        'Authorization':
            'Client-ID XDWzXd4imDt6zTLKxiLxSTzJu0Z2PU84qdswtvNCmx0',
      },
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    );

    final dio = Dio(options);
    List<String> imagesList = [];

    try {
      final response = await dio.get(
        '/search/photos',
        queryParameters: {
          'query': 'tesla model ${isModelY ? 'Y' : '3'}',
          'per_page': 20,
        },
      );

      // Extract image URLs from the response
      if (response.data != null && response.data['results'] != null) {
        final results = response.data['results'] as List;

        for (var image in results) {
          if (image['urls'] != null && image['urls']['small'] != null) {
            imagesList.add(image['urls']['small']);
          }
        }
      }
      return imagesList;
    } catch (e) {
      print("error fetching images: $e");
      return <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isModelY ? "Tesla Model Y" : "Tesla Model 3"),
        backgroundColor: Colors.grey[300],
      ),
      body: InfiniteScrollableGallery(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isModelY = !isModelY;
            getImagesFromUnsplash();
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
