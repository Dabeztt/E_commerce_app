import 'package:flutter/material.dart';
import 'package:doan/model/cart.dart';
import 'package:doan/data/sqlite.dart';
import 'package:doan/widget/subtitle_text.dart';
import 'package:doan/widget/title_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'quantity_bottom_sheet_widget.dart';

class CartWidget extends StatefulWidget {
  final Cart product;
  final VoidCallback onDelete;

  const CartWidget({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  void _updateQuantity(int newQuantity) async {
    setState(() {
      widget.product.count = newQuantity;
    });
    await DatabaseHelper()
        .updateProductQuantity(widget.product.productID, newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final totalPrice = widget.product.price * widget.product.count;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FittedBox(
        child: IntrinsicWidth(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FancyShimmerImage(
                  imageUrl: widget.product.img,
                  height: size.height * 0.2,
                  width: size.width * 0.4,
                ),
              ),
              const SizedBox(width: 10),
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: TitleTextWidget(
                            label: widget.product.name,
                            maxLine: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await DatabaseHelper()
                                    .deleteProduct(widget.product.productID);
                                widget.onDelete(); // Gọi callback onDelete
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                IconlyLight.heart,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SubtitleTextWidget(
                          label: NumberFormat('#,##0').format(totalPrice),
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return QuantityBottomSheetWidget(
                                  initialQuantity: widget.product.count,
                                  onUpdate: (newQuantity) {
                                    setState(() {
                                      widget.product.count = newQuantity;
                                    });
                                    _updateQuantity(newQuantity);
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            IconlyLight.arrowDown2,
                            color: Colors.blue,
                          ),
                          label: Text(
                            "Số lượng: ${widget.product.count}",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
