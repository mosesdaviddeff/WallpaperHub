// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/api_data.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/model/categories_model.dart';
import 'package:wallpaper_app/model/wallpaper_model.dart';
import 'package:wallpaper_app/pages/categories.dart';
import 'package:wallpaper_app/services/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});



@override
State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{

  List<CategoriesModel> categories =[];
  bool search = false;
  List<WallpaperModel> wallpaper =[];
  TextEditingController searchController = TextEditingController();

  Future<void> getTrendingWallpaper () async {
    var response = await http.get(
     Uri.parse("https://api.pexels.com/v1/curated?per_page=20"),
     headers: {"Authorization": apiKey},
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
    getTrendingWallpaper();
    categories = getCategories();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: 17.0,
            ),
          
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Wallpaper",
                      style: AppWidget.headlineTextStyle(25.0)
                    ),
                    Text(
                      "Hub", 
                      style: AppWidget.blueTextStyle(25.0),
                    )
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                //search functions
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Container(
                      
                      margin: EdgeInsets.only(
                        right: 30.0,
                        left: 30.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(54, 158, 158, 158),
                        borderRadius: BorderRadius.circular(30),
                        
                      ),
                      child: TextField(
                        
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: GestureDetector(
                            onTap: () {
                              wallpaper=[];
                              getSearchWallpaper(searchController.text);
                            },
                            child: Icon(Icons.search)),
                          hintText: "Search Wallpaper....",
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(73, 0, 0, 0),
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            
                          )
                          
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0
                    ),
                    itemCount: categories.length,
                    itemBuilder: ( context, int index) {
                      return CategoriesTile(
                        imgUrl: categories[index].imgUrl!,
                        title: categories[index].categoriesName!,
                      );
                    }
                    ),
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

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;
  const CategoriesTile(
    {super.key, 
    required this.imgUrl, 
    required this.title }
    );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Categories(categoryName: title)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 10,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(8),
      
              child: Image.network(
                imgUrl,
                height: 80,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 80,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}