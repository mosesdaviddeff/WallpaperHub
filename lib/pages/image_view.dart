import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/data/api_data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/pages/home.dart';

class ImageView extends StatefulWidget {
  final String imageUrl;
  final String? query;

  ImageView({super.key, required this.imageUrl, this.query});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  List<WallpaperModel> related = [];
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    fetchRelatedImages();
  }

  Future<void> fetchRelatedImages() async {
    setState(() => isLoading = true);
    try {
      final uri = widget.query != null && widget.query!.isNotEmpty
          ? Uri.parse(
              "https://api.pexels.com/v1/search?query=${Uri.encodeComponent(widget.query!)}&per_page=30",
            )
          : Uri.parse("https://api.pexels.com/v1/curated?per_page=30");

      final response = await http.get(uri, headers: {"Authorization": apiKey});
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      related.clear();
      if (jsonData.containsKey("photos")) {
        for (final elem in jsonData["photos"]) {
          related.add(WallpaperModel.fromMap(elem));
        }
      }
    } catch (e) {
      print("Related fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<bool> _requestSavePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    setState(() => isSaving = true);
    try {
      final granted = await _requestSavePermission();
      if (!granted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Permission denied")));
        return;
      }

      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = Uint8List.fromList(response.data);
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved to gallery")));
      print("Saved: $result");
    } catch (e) {
      print("Error saving image: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Save failed")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showDownloadDialog(String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Image options"),
          content: const Text(
            "Do you want to download this image to your gallery?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveImageToGallery(url);
              },
              child: const Text("Download"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: 6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return Container(
              height: (index.isEven ? 180 : 230),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
          staggeredTileBuilder: (index) =>
              StaggeredTile.extent(1, index.isEven ? 180 : 230),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top image area (set wallpaper section removed)
            Stack(
              children: [
                Hero(
                  tag: widget.imageUrl,
                  child: SizedBox(
                    height: topHeight,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          // Use InteractiveViewer + FittedBox for proper fitting and pan/zoom
                          child: InteractiveViewer(
                            panEnabled: true,
                            scaleEnabled: true,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: topHeight,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[900],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey[900]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Back button (use pop)
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    ),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                // Download button for main image (top-right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.black45,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _showDownloadDialog(widget.imageUrl),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Related grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                  right: 12,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "More like this",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    isLoading
                        ? _buildShimmerGrid()
                        : StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            itemCount: related.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final item = related[index];
                              final img = item.src?.portrait ?? widget.imageUrl;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        img,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: Colors.grey[900],
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            },
                                        errorBuilder: (_, __, ___) =>
                                            Container(color: Colors.grey[900]),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.15),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Material(
                                        color: Colors.black45,
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => _showDownloadDialog(img),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: isSaving
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.download_rounded,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.extent(
                                  1,
                                  index.isEven ? 220 : 270,
                                ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
