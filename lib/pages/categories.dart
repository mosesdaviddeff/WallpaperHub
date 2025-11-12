// ...existing code...
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/data/api_data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/pages/home.dart';
import 'package:wallpaper_app/services/support_widget.dart';
// ...existing code...

class Categories extends StatefulWidget {
  String categoryName;
  Categories(
    {super.key, 
      required this.categoryName,
    }
  );

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<WallpaperModel> wallpaper =[];
  bool isLoading = true;

  Future<void> getSearchWallpaper(String query) async {
    setState(() { isLoading = true; });
    try {
      var response = await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=30"),
        headers: {"Authorization": apiKey}
      );
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      wallpaper.clear();
      jsonData["photos"].forEach((elememt) {
        WallpaperModel wallpaperModel = WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(elememt);
        wallpaper.add(wallpaperModel);
      });
    } catch (e) {
      // keep short: simple error handling
      print("Categories fetch error: $e");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  @override
  void initState() {
    super.initState();
    getSearchWallpaper(
      widget.categoryName
    );
  }

  Widget _buildShimmerWallpaperLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(bottom: 4),
            );
          },
          staggeredTileBuilder: (index) => StaggeredTile.count(1, index.isEven ? 1.3 : 1.5),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
          child: Icon(Icons.arrow_back,
          color: Colors.blue,),
        ),
        backgroundColor: Colors.grey[850],
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [],
                ),
                SizedBox(
                  height: 20.0,
                ),
                isLoading
                  ? _buildShimmerWallpaperLoader()
                  : AppWidget().wallpaperList(
                      wallpaper: wallpaper, 
                      context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ...existing code...