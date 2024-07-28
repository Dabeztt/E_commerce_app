import 'package:doan/model/product.dart';
import 'package:doan/service/assets_manager.dart';
import 'package:doan/widget/app_name_text.dart';
import 'package:doan/widget/product/product_widget.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doan/data/api.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  late Future<List<ProductModel>> _products;
  List<ProductModel> _filteredProducts = [];
  List<ProductModel> _allProducts = [];

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
    _products = _fetchProducts();
  }

  Future<List<ProductModel>> _fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountID = prefs.getString('accountID') ?? '';
    String token = prefs.getString('token') ?? '';
    List<ProductModel> products =
        await APIRepository().getProduct(accountID, token);
    setState(() {
      _allProducts = products;
      _filteredProducts =
          products; // Initialize filtered products with all products
    });
    return products;
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const AppNameTextWidget(),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    IconlyLight.search,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchTextController.clear();
                        _filterProducts('');
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: const Icon(
                      IconlyLight.closeSquare,
                      color: Colors.red,
                    ),
                  ),
                ),
                onChanged: (value) {
                  _filterProducts(value);
                },
              ),
              Expanded(
                child: FutureBuilder<List<ProductModel>>(
                  future: _products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.asset(AssetsManager.emptySearch),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Không tìm thấy sản phẩm",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      List<ProductModel> productsToShow = _filteredProducts;
                      if (productsToShow.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(AssetsManager.emptySearch),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Không tìm thấy sản phẩm",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return DynamicHeightGridView(
                        builder: (context, index) {
                          return ProductWidget(product: productsToShow[index]);
                        },
                        itemCount: productsToShow.length,
                        crossAxisCount: 2,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
