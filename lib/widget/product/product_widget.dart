import 'package:doan/data/sqlite.dart';
import 'package:doan/model/cart.dart';
import 'package:doan/screen/product/product_detail.dart';
import 'package:doan/widget/product/heart_btn_widget.dart';
import 'package:doan/widget/subtitle_text.dart';
import 'package:doan/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doan/model/product.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;

  const ProductWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ProductDetail.routeName,
            arguments: product,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: FancyShimmerImage(
                imageUrl: product.imageUrl,
                height: size.height * 0.25,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: TitleTextWidget(
                      label: product.name,
                      maxLine: 2,
                      fontSize: 18,
                    ),
                  ),
                  const Flexible(
                    flex: 2,
                    child: HeartButtonWidget(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SubtitleTextWidget(
                      label: "${NumberFormat('#,##0').format(product.price)}"),
                  Material(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.lightBlue,
                    child: IconButton(
                      splashColor: Colors.red,
                      splashRadius: 27.0,
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
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
