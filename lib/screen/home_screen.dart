import 'package:card_swiper/card_swiper.dart';
import 'package:doan/const/app_constant.dart';
import 'package:doan/data/api.dart';
import 'package:doan/model/category.dart';
import 'package:doan/model/product.dart';
import 'package:doan/screen/product/all_product.dart';
import 'package:doan/service/assets_manager.dart';
import 'package:doan/widget/app_name_text.dart';
import 'package:doan/widget/product/ctg_rounded_widget.dart';
import 'package:doan/widget/product/latest_arrival_product.dart';
import 'package:doan/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ProductModel>> _productsFuture;
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
    _categoriesFuture = _fetchCategories(); // Khởi tạo _categoriesFuture ở đây
  }

  Future<List<ProductModel>> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getProduct(
      prefs.getString('accountID') ?? '',
      prefs.getString('token') ?? '',
    );
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
      prefs.getString('accountID') ?? '',
      prefs.getString('token') ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerSlider(size),
              const SizedBox(height: 18),
              const TitleTextWidget(
                label: "Danh mục",
                fontSize: 22,
              ),
              const SizedBox(height: 18),
              _buildCategoryGrid(),
              const SizedBox(height: 18),
              _buildSection('Sản phẩm mới nhất', _productsFuture),
              const SizedBox(height: 18),
              _buildSection('Sản phẩm đang hot', _productsFuture),
              const SizedBox(height: 18),
              _buildSection('Sản phẩm bán chạy nhất', _productsFuture),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        height: size.height * 0.24,
        child: Swiper(
          itemBuilder: (context, index) {
            return Image.asset(
              AppConstant.bannersImages[index],
              fit: BoxFit.cover,
            );
          },
          itemCount: AppConstant.bannersImages.length,
          autoplay: true,
          pagination: const SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories available'));
        } else {
          final categories = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryRoundedWidget(
                image: categories[index].imageUrl,
                name: categories[index].name,
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSection(
      String title, Future<List<ProductModel>> productsFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllProductsScreen(),
                  ),
                );
              },
              child: const Row(
                children: [
                  Text('Xem thêm'),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ],
        ),
        FutureBuilder<List<ProductModel>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              final products = snapshot.data!;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 15.0), // Khoảng cách giữa các sản phẩm
                      child: LatestArrivalProductWidget(
                        product: products[index],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
