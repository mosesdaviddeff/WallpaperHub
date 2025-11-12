import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_app/pages/home.dart';

class ImageView extends StatefulWidget {
  String imageUrl;
  ImageView ({super.key, 
    required this.imageUrl
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
        
      //   title: GestureDetector(
      //     onTap: () {
      //      // Navigator.pop(context);
      //       // Navigator.of(context).pushReplacement(
      //       //   MaterialPageRoute(builder: (context) => Home())
      //       // );
           
      //     },
      //     child: Text(
      //             "Cancel",
      //             style: TextStyle(
      //               color: Colors.black,
      //               fontFamily: 'Poppins'
      //             ),
      //           ),
      //   ),
      // ),
      body: Stack(
        children: [
          Hero(
            tag: widget, 
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageUrl, fit: BoxFit.cover,
              ),
            )),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width/1.8,
                        decoration: BoxDecoration(
                          color: Color(0xff1c1b1b),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width/1.8,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54,
                          width: 1),
                          borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(colors: [
                      Color(0x36ffffff), 
                      Color(0x0fffffff)]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Set Wallpaper",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Poppins'
                              ),
                            ),
                            Text(
                              "Image will be saved in Gallery",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16.0,
            ),

            //cancel function
            Padding
            (padding: const EdgeInsets.only(left: 20, top: 20),
            child: GestureDetector(
          onTap: () {
            //Navigator.pop(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home())
            );
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30, 
            ),
          ),
          
          // child: Text(
          //         "Cancel",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontFamily: 'Poppins',
          //           fontSize: 25,
          //         ),
          //       ),
        ),
            ),
        ],
      ),
    );
  }

  //save function
  Future<void> saveImageToGallery(String imageUrl) async {
    //ask for permission
    var status = await Permission.photos.request();
    if(status.isGranted) {
      try{
        var response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes)
        );

        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
        );
        print("✅ Saved Successfully: $result");
      }catch (e) {
        print("❌ Error Saving Image: $e");
      } 
    }else {
        print("❌ Permission Denied");
      }
  }
}