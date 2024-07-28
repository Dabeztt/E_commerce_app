import 'package:doan/widget/product/product_widget.dart';
import 'package:doan/widget/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:doan/data/api.dart';
import 'package:doan/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductScreen({super.key, required this.categoryName});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<ProductModel> allProducts = await APIRepository().getProduct(
        prefs.getString('accountID') ?? '',
        prefs.getString('token') ?? '',
      );

      // Lọc sản phẩm theo danh mục
      return allProducts
          .where((product) => product.categoryName == widget.categoryName)
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitleTextWidget(
              label: widget.categoryName), // Hiển thị tên danh mục
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<ProductModel>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No products available"));
              } else {
                List<ProductModel> products = snapshot.data!;
                return DynamicHeightGridView(
                  builder: (context, index) {
                    return ProductWidget(product: products[index]);
                  },
                  itemCount: products.length,
                  crossAxisCount: 2,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
