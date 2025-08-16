import 'package:flutter/material.dart';
import 'package:tesla_gallery/get_images_from_unsplash.dart';

// The InfiniteScrollableGallery widget displays a grid of Tesla images
class InfiniteScrollableGallery extends StatefulWidget {
  final bool isModelY;

  const InfiniteScrollableGallery({super.key, required this.isModelY});

  @override
  State<InfiniteScrollableGallery> createState() =>
      _InfiniteScrollableGalleryState();
}

class _InfiniteScrollableGalleryState extends State<InfiniteScrollableGallery> {
  late ScrollController _scrollController;
  int page = 1;
  DateTime? _lastScrollTime;
  List<String> allImages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadInitialImages();
  }

  @override
  void didUpdateWidget(InfiniteScrollableGallery oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isModelY != widget.isModelY) {
      _resetGallery();
    }
  }

  void _resetGallery() {
    setState(() {
      allImages.clear();
      page = 1;
      isLoading = false;
    });
    _loadInitialImages();
  }

  void _loadInitialImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newImages = await getImagesFromUnsplash(
        widget.isModelY ? 'Y' : '3',
        page,
      );

      setState(() {
        allImages = newImages;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadMoreImages() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newImages = await getImagesFromUnsplash(
        'tesla model ${widget.isModelY ? 'Y' : '3'}',
        page,
      );

      setState(() {
        allImages.addAll(newImages);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final now = DateTime.now();

      if (_lastScrollTime == null ||
          now.difference(_lastScrollTime!).inSeconds >= 1) {
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: allImages.length + (isLoading ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index >= allImages.length) {
                      return const Center(child: CircularProgressIndicator());
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
