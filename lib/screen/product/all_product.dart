import 'package:doan/model/product.dart';
import 'package:doan/widget/product/product_widget.dart';
import 'package:doan/widget/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doan/data/api.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _products = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountID = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    return await APIRepository().getProduct(accountID, token);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(label: "Tất cả sản phẩm"),
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
            future: _products,
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
