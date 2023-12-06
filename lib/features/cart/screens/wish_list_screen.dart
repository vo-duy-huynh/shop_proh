import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/common/widgets/bottom_bar.dart';
import 'package:shop_proh/features/cart/services/cart_services.dart';
import 'package:shop_proh/models/product.dart';
import 'package:shop_proh/providers/user_provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  Product? product;
  bool isCheckAll = false;
  List<bool> isCheckedList = [];
  final CartServices cartServices = CartServices();
  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      BottomBar.routeName,
      (route) => false,
    );
  }

  final numberFormat = NumberFormat("#,##0", "en_US");

  void increaseQuantity(Product product) {
    cartServices.addToWishList(
      context: context,
      product: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách yêu thích',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(0, 207, 17, 17),
        foregroundColor: const Color.fromARGB(255, 185, 13, 13),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Danh sách sản phẩm
              Column(
                children: user.cart.map((cartItem) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            cartItem['product']['images'][0],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem['product']['name'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${numberFormat.format(cartItem['product']['price'])} đ',
                              style: const TextStyle(
                                color: Color(0xFFFD725A),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                increaseQuantity(Product.fromMap(
                                    cartItem['product']
                                        as Map<String, dynamic>));
                              },
                              child: Icon(CupertinoIcons.trash,
                                  color: Color(0xFFFD725A)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              Divider(thickness: 1, color: Colors.grey),

              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  navigateToHomeScreen(context);
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFD725A),
                  ),
                  child: const Center(
                    child: Text(
                      'Trở về trang chủ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
