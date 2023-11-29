import 'package:flutter/material.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/features/account/widgets/single_product.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List images = [
    'https://images-na.ssl-images-amazon.com/images/I/71tT8J5cKuL._SL1500_.jpg',
    'https://lh3.googleusercontent.com/aQmeKEIo3ADYyECtEhEc7G-lMTGhxN3_KWdawSV0IoSuEE_7ijJt2jEn6ij6NopAr4f9cp642DYFjj9oabFyLanmCdjr-1fV=w500-rw',
    'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:80/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-13_2_.png',
  ];
  // final AccountServices accountServices = AccountServices();

  // @override
  // void initState() {
  //   super.initState();
  //   fetchOrders();
  // }

  // void fetchOrders() async {
  //   orders = await accountServices.fetchMyOrders(context: context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        // display orders
        Container(
          height: 170,
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            right: 0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return SingleProduct(
                image: images[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
