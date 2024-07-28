import 'package:doan/widget/product/product_widget.dart';
import 'package:doan/widget/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:doan/model/product.dart';

class WishlistScreen extends StatefulWidget {
  static const routeName = "/WishlistScreen";
  final List<ProductModel> favoriteProducts;

  const WishlistScreen({required this.favoriteProducts, super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const TitleTextWidget(label: "Sản phẩm yêu thích"),
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
          child: Column(
            children: [
              Expanded(
                child: DynamicHeightGridView(
                  builder: (context, index) {
                    return ProductWidget(
                        product: widget.favoriteProducts[index]);
                  },
                  itemCount: widget.favoriteProducts.length,
                  crossAxisCount: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
