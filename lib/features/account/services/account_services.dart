import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/constants/error_handling.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/models/order.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/v1/user/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body)['data'].length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)['data'][i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }
}
