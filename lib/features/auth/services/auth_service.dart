// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_proh/common/widgets/bottom_bar.dart';
import 'package:shop_proh/constants/error_handling.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/responseHandle.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/screens/otp_screen.dart';
import 'package:shop_proh/features/auth/screens/resetpassword_screen.dart';
import 'package:shop_proh/home/screens/home_screen.dart';
import 'package:shop_proh/main.dart';
import 'package:shop_proh/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shop_proh/providers/user_provider.dart';

class AuthService {
  void signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        password: password,
        name: name,
        address: '',
        type: '',
        token: '',
        cart: [],
        wishlist: [],
      );
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/auth/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'Đăng ký thành công!!!',
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AuthScreen.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, 'Đăng nhập thành công!!!');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var responseData = jsonDecode(res.body)['data'];
          Provider.of<UserProvider>(context, listen: false)
              .setUser(jsonEncode(responseData));
          await saveTokenToStorage(responseData['token']);
          await saveTypeToStorage(responseData['type']);
          await prefs.setString('x-auth-token', responseData['token']);
          showSnackBar(context, 'Đăng nhập thành công!!!');
          print(responseData['type']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void forGotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/auth/forgotPassword'),
        body: jsonEncode({
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Đã gửi email xác nhận!!!');
          Navigator.pushNamedAndRemoveUntil(
            context,
            OtpScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void otpCheck({
    required BuildContext context,
    required String otp,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/auth/resetpassword'),
        body: jsonEncode({
          'otp': otp,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Xác nhận thành công!!!');
          var responseData = jsonDecode(res.body)['data'];
          Navigator.pushNamedAndRemoveUntil(
            context,
            ResetPassWordScreen.routeName,
            arguments: responseData['email'],
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void resetPassWord({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.put(
        Uri.parse('$uri/api/v1/auth/resetPassword'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Đổi mật khẩu thành công!!!');
          Navigator.pushNamedAndRemoveUntil(
            context,
            AuthScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> saveTokenToStorage(String token) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'x-auth-token', value: token);
  }

  Future<void> saveTypeToStorage(String type) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'type', value: type);
  }

  Future<void> removeTokenFromStorage() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'x-auth-token');
  }

  Future<void> removeTypeFromStorage() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'type');
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.get(
        Uri.parse('$uri/api/v1/auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body)['success'];

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // ignore: use_build_context_synchronously
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await removeTokenFromStorage();
      await removeTypeFromStorage();
      await sharedPreferences.remove('x-auth-token');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
