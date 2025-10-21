
import 'package:wallpaper_app/model/categories_model.dart';

List<CategoriesModel> getCategories(){
  List<CategoriesModel> categories = [];
  CategoriesModel categoriesModel = CategoriesModel();

  //Street Art category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/162379/lost-places-pforphoto-leave-factory-162379.jpeg";
  categoriesModel.categoriesName = "Street Art";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  //Wild Life category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/16066/pexels-photo.jpg";
  categoriesModel.categoriesName = "Wild Life";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  //Nature category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/247599/pexels-photo-247599.jpeg";
  categoriesModel.categoriesName = "Nature";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  //city category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/290595/pexels-photo-290595.jpeg";
  categoriesModel.categoriesName = "City";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();


  //Motivation category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/2045600/pexels-photo-2045600.jpeg";
  categoriesModel.categoriesName = "Motivation";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();


  //bikess category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/1191109/pexels-photo-1191109.jpeg";
  categoriesModel.categoriesName = "Bikes";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  //cars category
  categoriesModel.imgUrl = "https://images.pexels.com/photos/120049/pexels-photo-120049.jpeg";
  categoriesModel.categoriesName = "Cars";
  categories.add(categoriesModel);
  categoriesModel = CategoriesModel();

  return categories;
}
