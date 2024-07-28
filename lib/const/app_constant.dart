import 'package:doan/model/category.dart';
import 'package:doan/service/assets_manager.dart';

class AppConstant {
  static String productImageUrl =
      "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/4f37fca8-6bce-43e7-ad07-f57ae3c13142/air-force-1-07-shoes-WrLlWX.png";

  static String urlLogo = "asset/image/logo.png";

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];

  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: 1,
      name: "Điện thoại",
      imageUrl: AssetsManager.mobiles,
      desc: "Bán điện thoại",
    ),
    CategoryModel(
      id: 2,
      name: "Laptop",
      imageUrl: AssetsManager.pc,
      desc: "Bán laptop",
    ),
    CategoryModel(
      id: 3,
      name: "Đồ điện",
      imageUrl: AssetsManager.electronics,
      desc: "Bán đồ điện",
    ),
    CategoryModel(
      id: 4,
      name: "Đồng hồ",
      imageUrl: AssetsManager.watch,
      desc: "Bán đồng hồ",
    ),
    CategoryModel(
      id: 5,
      name: "Giày",
      imageUrl: AssetsManager.shoes,
      desc: "Bán giày",
    ),
    CategoryModel(
      id: 6,
      name: "Sách",
      imageUrl: AssetsManager.book,
      desc: "Bán sách",
    ),
    CategoryModel(
      id: 7,
      name: "Mỹ phẩm",
      imageUrl: AssetsManager.cosmetics,
      desc: "Bán mỹ phẩm",
    ),
  ];
}
