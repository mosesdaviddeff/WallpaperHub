import 'package:flutter/material.dart';
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

  static TextStyle blueTextStyle(double size){
    return TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Poppins',
                      fontSize: size,
                    );

  }

  Widget wallpaperList({required List<WallpaperModel> wallpaper, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
  
    child: GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpaper.map((wallpapers) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              // Your onTap logic here
              Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ImageView(imageUrl: wallpapers.src!.portrait)),
      );
            },
            child: Hero(
              tag: wallpapers.src!.portrait,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    wallpapers.src!.portrait,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

}