import 'package:doan/model/product.dart';
import 'package:doan/widget/product/product_widget.dart';
import 'package:doan/widget/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';

class RecentlyViewedScreen extends StatefulWidget {
  static const routeName = "/RecentlyViewedScreen";
  final List<ProductModel>
      recentlyViewedProducts; // Pass the data via constructor
  const RecentlyViewedScreen({super.key, required this.recentlyViewedProducts});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
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
          title: const TitleTextWidget(label: "Đã xem gần đây"),
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
                        product: widget.recentlyViewedProducts[index]);
                  },
                  itemCount: widget.recentlyViewedProducts.length,
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
