import 'package:flutter/material.dart';
import 'package:tesla_gallery/get_images_from_unsplash.dart';

class InfiniteScrollableGallery extends StatefulWidget {
  final bool isModelY;

  const InfiniteScrollableGallery({super.key, required this.isModelY});

  @override
  State<InfiniteScrollableGallery> createState() => _InfiniteScrollableGalleryState();
}

class _InfiniteScrollableGalleryState extends State<InfiniteScrollableGallery> {
  late ScrollController _scrollController;
  int page = 1;
  DateTime? _lastScrollTime;
  List<String> allImages = [];
  bool isLoading = false;

  @override
  void initState() {
    print('Initializing InfiniteScrollableGallery with isModelY: ${widget.isModelY}');
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadInitialImages();
  }

  @override
  void didUpdateWidget(InfiniteScrollableGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if isModelY changed
    if (oldWidget.isModelY != widget.isModelY) {
      print('Toggle changed! Resetting gallery. New isModelY: ${widget.isModelY}');
      _resetGallery();
    }
  }

  void _resetGallery() {
    setState(() {
      allImages.clear(); // Empty the list
      page = 1; // Reset page to 1
      isLoading = false;
    });
    _loadInitialImages(); // Load new images for the new model
  }

  void _loadInitialImages() async {
    print('Loading initial images for ${widget.isModelY ? 'Model Y' : 'Model 3'}');
    setState(() {
      isLoading = true;
    });
    
    try {
      final newImages = await getImagesFromUnsplash(
        widget.isModelY ? 'Y' : '3', 
        page
      );
      
      setState(() {
        allImages = newImages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading initial images: $e');
    }
  }

  void _loadMoreImages() async {
    print('Loading more images for page $page');
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
    });
    
    try {
      final newImages = await getImagesFromUnsplash(
        'tesla model ${widget.isModelY ? 'Y' : '3'}', 
        page
      );
      
      setState(() {
        allImages.addAll(newImages); // Append new images to existing list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading more images: $e');
    }
  }

  @override
  void dispose() {
    print('Disposing InfiniteScrollableGallery');
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final now = DateTime.now();
      
      // Check if 1 second has passed since last call
      if (_lastScrollTime == null || now.difference(_lastScrollTime!).inSeconds >= 1) {
        _lastScrollTime = now;
        
        page++;
        _loadMoreImages();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Expanded(
          child: allImages.isEmpty && isLoading
              ? const Center(child: CircularProgressIndicator())
              : allImages.isEmpty
                  ? const Center(child: Text('No images found'))
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0, // Square images
                      ),
                      itemCount: allImages.length + (isLoading ? 2 : 0), // Add loading items
                      itemBuilder: (context, index) {
                        if (index >= allImages.length) {
                          // Show loading indicator at the bottom
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              allImages[index],
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