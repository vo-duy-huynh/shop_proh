import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_proh/common/widgets/loader.dart';
import 'package:shop_proh/features/product_details/screens/product_details_screen.dart';
import 'package:shop_proh/home/screens/all_products_screen.dart';
import 'package:shop_proh/home/services/home_services.dart';
import 'package:shop_proh/models/product.dart';

class DealOfDayTest extends StatefulWidget {
  // lấy category id
  final Product? product;
  const DealOfDayTest({Key? key, required this.product}) : super(key: key);

  @override
  State<DealOfDayTest> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDayTest> {
  Product? product;
  List<Product> productList = [];
  final HomeServices homeServices = HomeServices();
  final numberFormat = NumberFormat("#,##0", "en_US");
  String categoryId = '';
  @override
  void initState() {
    super.initState();
    // fetchDealOfDay();
    product = widget.product;
  }

  // void fetchDealOfDay() async {
  //   product = await homeServices.fetchDealOfDay(context: context);
  //   setState(() {});
  // }
  // void fetchByCategory() async {
  //   productList = await homeServices.fetchByCategory(categoryId: categoryId, context: context);
  //   setState(() {});
  // }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  void navigateToAllProductsScreen() {
    Navigator.pushNamed(context, AllProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetailScreen,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Color.fromARGB(255, 224, 244, 244),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: navigateToDetailScreen,
                              child: Image.network(
                                product!.images[0],
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product!.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${numberFormat.format(product!.price)} đ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Positioned(
                              top: 20.0,
                              right: 0.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 15),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 60, 189, 64),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 1),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
