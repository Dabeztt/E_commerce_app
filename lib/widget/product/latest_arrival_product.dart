import 'package:doan/data/sqlite.dart';
import 'package:doan/model/cart.dart';
import 'package:doan/model/product.dart';
import 'package:doan/screen/product/product_detail.dart';
import 'package:doan/widget/subtitle_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

class LatestArrivalProductWidget extends StatelessWidget {
  final ProductModel product; // Add product data as a required parameter

  const LatestArrivalProductWidget({
    super.key,
    required this.product, // Require product data
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Format price outside of constant expressions
    final formattedPrice = NumberFormat('#,##0').format(product.price);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetail.routeName,
            arguments:
                product, // Pass the product data to the ProductDetail screen
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FancyShimmerImage(
                    imageUrl: product.imageUrl,
                    width: size.width * 0.28,
                    height: size.height * 0.28,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Handle adding to wishlist
                            },
                            icon: const Icon(
                              IconlyLight.heart,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              Cart cartItem = Cart(
                                productID: product.id,
                                name: product.name,
                                price: product.price,
                                img: product.imageUrl,
                                des: product.description,
                                count: 1,
                              );

                              await DatabaseHelper().insertProduct(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product.name} đã được thêm vào giỏ hàng'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "$formattedPrice", // Use the formatted price
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
