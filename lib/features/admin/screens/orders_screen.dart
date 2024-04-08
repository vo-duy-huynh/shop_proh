import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/common/widgets/loader.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/features/account/widgets/single_product.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/features/order_details/screens/order_details.dart';
import 'package:shop_proh/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop_proh/providers/user_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  void navigateToOrderDetail(Order orderData) {
    Navigator.pushNamed(
      context,
      OrderDetailScreen.routeName,
      arguments: orderData,
    );
  }

  Future<String> fetchUserName(String userId) async {
    final response = await http.get(
      Uri.parse('$uri/api/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': context.read<UserProvider>().user!.token!,
      },
    );
    final data = jsonDecode(response.body);
    return data['name'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Danh sách đơn hàng'),
      ),
      body: orders == null
          ? const Loader()
          : ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: orders!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final orderData = orders![index];

                    return FutureBuilder<String>(
                      future: fetchUserName(orderData.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            // Handle error
                            return Text('Error loading username');
                          }
                          final userName = snapshot.data;

                          return Card(
                            elevation: 3.0,
                            child: InkWell(
                              onTap: () {
                                navigateToOrderDetail(orderData);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            orderData.products![0].images![0]
                                                as String,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      // tên người đặt hàng
                                      userName ?? 'Unknown User',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // ngày đặt hàng
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      orderData.date! as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // If the Future is still running, return a loading indicator
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
