import 'package:flutter/material.dart';

class InfiniteScrollableGallery extends StatefulWidget {
  const InfiniteScrollableGallery({super.key});

  @override
  State<InfiniteScrollableGallery> createState() => _InfiniteScrollableGalleryState();
}

class _InfiniteScrollableGalleryState extends State<InfiniteScrollableGallery> {
  final List<String> testImages = [
  'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=400',
  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
  'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400',
  'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=400',
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0, // Square images
              ),
              itemCount: testImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      testImages[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
}