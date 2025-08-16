import 'package:dio/dio.dart';

/// Fetches images from Unsplash based on the Tesla model type and page number.
Future<List<String>> getImagesFromUnsplash(String keyword, int page) async {
  final options = BaseOptions(
    baseUrl: 'https://api.unsplash.com',
    headers: {
      'Authorization': 'Client-ID XDWzXd4imDt6zTLKxiLxSTzJu0Z2PU84qdswtvNCmx0',
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
        'query': 'tesla model $keyword',
        'per_page': 20,
        'page': page,
      },
    );

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
