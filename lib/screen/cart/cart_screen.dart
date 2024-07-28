import 'package:doan/data/api.dart';
import 'package:doan/data/sqlite.dart';
import 'package:doan/model/cart.dart';
import 'package:doan/screen/cart/cart_widget.dart';
import 'package:doan/service/assets_manager.dart';
import 'package:doan/widget/app_name_text.dart';
import 'package:doan/widget/empty_bag_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isOrdering = false; // Track ordering state

  Stream<List<Cart>> _getProductsStream() async* {
    while (true) {
      yield await _databaseHelper.products();
      await Future.delayed(const Duration(seconds: 1)); // Refresh every second
    }
  }

  double _calculateTotal(List<Cart> products) {
    double total = 0;
    for (var product in products) {
      total += product.price * product.count;
    }
    return total;
  }

  void _showOrderSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đặt hàng thành công!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: StreamBuilder<List<Cart>>(
          stream: _getProductsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return EmptyBagWidget(
                imagePath: AssetsManager.shoppingBasket,
                title: "Giỏ hàng đang trống",
              );
            }
            return Column(
              children: [
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final itemProduct = snapshot.data![index];
                        return CartWidget(
                          product: itemProduct,
                          onDelete: () =>
                              setState(() {}), // Thông báo khi có thay đổi
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        NumberFormat('#,##0')
                            .format(_calculateTotal(snapshot.data!)),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isOrdering
                            ? null
                            : () async {
                                setState(() {
                                  _isOrdering = true;
                                });
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                List<Cart> temp =
                                    await _databaseHelper.products();
                                await APIRepository().addBill(
                                    temp, pref.getString('token').toString());
                                _databaseHelper.clear();
                                setState(() {
                                  _isOrdering = false;
                                });
                                _showOrderSuccessMessage(); // Show success message
                              },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: _isOrdering
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                "Thanh toán",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
