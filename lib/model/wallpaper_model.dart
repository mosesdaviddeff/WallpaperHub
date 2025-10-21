class WallpaperModel {
    String? photographer;
    int? photographerId;
    String? photographerUrl;
    
    SrcModel? src;

    WallpaperModel(
      {
         this.photographer,
         this.photographerId,
         this.photographerUrl,
         this.src,
      }
    );

    factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
      return WallpaperModel(
        photographer: jsonData["photographer_url"], 
        photographerId: jsonData["photographer_id"], 
        photographerUrl: jsonData["photographer"], 
        src: SrcModel.fromMap(jsonData["src"]
        ),
        );
    }

}

class SrcModel {
    String original;
    String small;
    String portrait;

    SrcModel(
      {
      required this.original,
      required this.small,
      required this.portrait,
      }
    );

    factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
      return SrcModel(
        original: jsonData["original"], 
        small: jsonData["small"], 
        portrait: jsonData["portrait"],
        );
    } 
}