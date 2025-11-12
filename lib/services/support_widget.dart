import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/pages/image_view.dart';

class AppWidget {

  static TextStyle headlineTextStyle(double size){
    return TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: size,
                    );
  }

  static TextStyle whiteheadlineTextStyle(double size){
    return TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: size,
                    );
  }

  static TextStyle blueTextStyle(double size){
    return TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                      fontSize: size,
                    );
  }

  Widget wallpaperList({required List<WallpaperModel> wallpaper, required BuildContext context}) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: wallpaper.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ImageView(imageUrl: wallpaper[index].src!.portrait),
              ),
            );
          },
          child: Hero(
            tag: wallpaper[index].src!.portrait,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                wallpaper[index].src!.portrait,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 3),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    );
  }
}