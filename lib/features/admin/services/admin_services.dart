import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_proh/constants/error_handling.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/models/category.dart';
import 'package:shop_proh/models/order.dart';
import 'package:shop_proh/providers/user_provider.dart';
import 'package:shop_proh/models/product.dart';
import 'package:http/http.dart' as http;

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String categoryId,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dvcwwbrqw', 'k4zpogr3');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: categoryId,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Thêm sản phẩm thành công!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  // update product
  void updateProduct({
    required BuildContext context,
    required Product product,
    final String? name,
    final String? description,
    final double? price,
    final double? quantity,
    final List<File>? images,
    final String? categoryId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      if (images == null) {
        http.Response resHttp = await http.put(
          Uri.parse('$uri/admin/update-product/${product.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'name': name ?? product.name,
            'description': description ?? product.description,
            'price': price ?? product.price,
            'quantity': quantity ?? product.quantity,
            'category': categoryId ?? product.category,
            'images': product.images,
          }),
        );

        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: resHttp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Cập nhật sản phẩm thành công!');
            Navigator.pop(context);
          },
        );
      } else {
        final cloudinary = CloudinaryPublic('dvcwwbrqw', 'k4zpogr3');
        List<String> imageUrls = [];

        for (int i = 0; i < images.length; i++) {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: name),
          );
          imageUrls.add(res.secureUrl);
        }

        http.Response resHttp = await http.put(
          Uri.parse('$uri/admin/update-product/${product.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'name': name ?? product.name,
            'description': description ?? product.description,
            'price': price ?? product.price,
            'quantity': quantity ?? product.quantity,
            'category': categoryId ?? product.category,
            'images': imageUrls,
          }),
        );

        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: resHttp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Cập nhật sản phẩm thành công!');
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void sellCategory({
    required BuildContext context,
    required String name,
    final String? description,
    required File imageCover,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final cloudinary = CloudinaryPublic('dvcwwbrqw', 'k4zpogr3');
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageCover.path, folder: name),
      );
      Category category = Category(
        name: name,
        description: description,
        imageCover: res.secureUrl,
      );

      http.Response resHttp = await http.post(
        Uri.parse('$uri/admin/add-category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: category.toJson(),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: resHttp,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Thêm danh mục thành công!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void updateCategory({
    required BuildContext context,
    required Category category,
    final String? name,
    final String? description,
    final File? imageCover,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      if (imageCover == null) {
        http.Response resHttp = await http.put(
          Uri.parse('$uri/admin/update-category/${category.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'name': name ?? category.name,
            'description': description ?? category.description,
            'imageCover': category.imageCover,
          }),
        );

        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: resHttp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Cập nhật danh mục thành công!');
            Navigator.pop(context);
          },
        );
      } else {
        final cloudinary = CloudinaryPublic('dvcwwbrqw', 'k4zpogr3');
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(imageCover.path, folder: name),
        );

        http.Response resHttp = await http.put(
          Uri.parse('$uri/admin/update-category/${category.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: jsonEncode({
            'name': name ?? category.name,
            'description': description ?? category.description,
            'imageCover': res.secureUrl,
          }),
        );

        // ignore: use_build_context_synchronously
        httpErrorHandle(
          response: resHttp,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Cập nhật danh mục thành công!');
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteCategory({
    required BuildContext context,
    required Category category,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/admin/delete-category/${category.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // fetch all the categories
  Future<List<Category>> fetchAllCategories(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Category> categoryList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-categories'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            categoryList.add(
              Category.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return categoryList;
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/admin/delete-product/${product.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
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

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
