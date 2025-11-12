import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';
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
  bool isLoading = true;
  bool isCategoriesLoading = true;
  List<WallpaperModel> wallpaper =[];
  TextEditingController searchController = TextEditingController();

  Future<void> getTrendingWallpaper () async {
    try {
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
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getSearchWallpaper(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=30"),
      headers: {"Authorization": apiKey}
      );
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      wallpaper.clear();
      jsonData ["photos"].forEach((elememt) {
        WallpaperModel wallpaperModel = WallpaperModel();
        wallpaperModel = WallpaperModel.fromMap(elememt);
        wallpaper.add(wallpaperModel);
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTrendingWallpaper();
    categories = getCategories();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isCategoriesLoading = false;
      });
    });
  }

  Widget _buildShimmerWallpaperLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[900]!,
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
          staggeredTileBuilder: (index) => StaggeredTile.count(1, index.isEven ? 1.3 : 1.5),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
      ),
    );
  }

  Widget _buildCategoriesShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              width: 150,
              height: 80,
            );
          },
        ),
      ),
    );
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Kallos",
                        style: AppWidget.whiteheadlineTextStyle(25.0)
                      ),
                      Text(
                        "Hub", 
                        style: AppWidget.blueTextStyle(25.0),
                      )
                    ],
                  ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if(searchController.text.isNotEmpty) {
                                getSearchWallpaper(searchController.text);
                              }
                            },
                            child: Icon(Icons.search)),
                          hintText: "Search Wallpaper....",
                          hintStyle: TextStyle(
                            color:  Colors.white70,
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
                isCategoriesLoading
                  ? _buildCategoriesShimmer()
                  : SizedBox(
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

      //navBar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile")
          
        ],
    ));
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
              borderRadius: BorderRadius.circular(8),
      
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