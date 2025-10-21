import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/data/api_data.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/pages/home.dart';
import 'package:wallpaper_app/services/support_widget.dart';

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


Future<void> getSearchWallpaper(String query) async {
    var response = await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=30"),
    headers: {"Authorization": apiKey}
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData ["photos"].forEach((elememt) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(elememt);
      wallpaper.add(wallpaperModel);
    });
    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSearchWallpaper(
      widget.categoryName
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
        backgroundColor: Colors.white,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            color: Colors.black,
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
                    AppWidget().wallpaperList(
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