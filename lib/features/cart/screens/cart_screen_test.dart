import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/features/address/screens/address_screen.dart';
import 'package:shop_proh/features/cart/services/cart_services.dart';
import 'package:shop_proh/features/search/screens/search_screens.dart';
import 'package:shop_proh/models/product.dart';
import 'package:shop_proh/providers/user_provider.dart';

class CartScreenTest extends StatefulWidget {
  const CartScreenTest({super.key});

  @override
  State<CartScreenTest> createState() => _CartScreenTestState();
}

class _CartScreenTestState extends State<CartScreenTest> {
  Product? product;
  bool isCheckAll = true;
  List<bool> isCheckedList = [];
  final CartServices cartServices = CartServices();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  final numberFormat = NumberFormat("#,##0", "en_US");
  void navigateToAddressScreen(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }

  void increaseQuantity(Product product) {
    cartServices.addToCart(
      context: context,
      product: product,
    );
  }

  void decreaseQuantity(Product product) {
    cartServices.removeFromCart(
      context: context,
      product: product,
    );
  }

  int calculateTotal(List<bool> isCheckedList) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    for (int i = 0; i < user.cart.length; i++) {
      if (isCheckedList[i]) {
        sum +=
            user.cart[i]['product']['price'] * user.cart[i]['quantity'] as int;
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (isCheckedList.isEmpty) {
      isCheckedList = List.generate(user.cart.length, (index) => true);
    }
    int sum = calculateTotal(isCheckedList);
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        leading: BackButton(),
        backgroundColor: Color.fromARGB(0, 207, 17, 17),
        foregroundColor: const Color.fromARGB(255, 185, 13, 13),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Danh sách sản phẩm
              Column(
                children: user.cart.map((cartItem) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          splashRadius: 15,
                          activeColor: Color(0xFFFD725A),
                          value: isCheckedList[user.cart.indexOf(cartItem)],
                          onChanged: (value) {
                            setState(() {
                              isCheckedList[user.cart.indexOf(cartItem)] =
                                  value!;
                              isCheckAll =
                                  isCheckedList.every((element) => element);
                            });
                          },
                        ),
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
                        SizedBox(width: 5),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                decreaseQuantity(Product.fromMap(
                                    cartItem['product']
                                        as Map<String, dynamic>));
                              },
                              child: Icon(CupertinoIcons.minus,
                                  color: Color(0xFFFD725A)),
                            ),
                            SizedBox(width: 5),
                            Text(cartItem['quantity'].toString()),
                            SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                increaseQuantity(Product.fromMap(
                                    cartItem['product']
                                        as Map<String, dynamic>));
                              },
                              child: Icon(CupertinoIcons.plus,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chọn tất cả",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    splashRadius: 20,
                    activeColor: Color(0xFFFD725A),
                    value: isCheckAll,
                    onChanged: (value) {
                      setState(() {
                        isCheckAll = value!;
                        isCheckedList = List.generate(
                            user.cart.length, (index) => isCheckAll);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng tiền: ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${numberFormat.format(sum)} đ',
                    style: TextStyle(
                        color: Color(0xFFFD725A),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Nút thanh toán
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  navigateToAddressScreen(sum);
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
                      'Thanh toán',
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
