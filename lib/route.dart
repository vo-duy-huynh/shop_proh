import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/bottom_bar.dart';
import 'package:shop_proh/features/address/screens/address_screen.dart';
import 'package:shop_proh/features/admin/screens/add_category_screen.dart';
import 'package:shop_proh/features/admin/screens/add_product_screen.dart';
import 'package:shop_proh/features/admin/screens/update_category_screen.dart';
import 'package:shop_proh/features/admin/screens/update_product_screen.dart';
import 'package:shop_proh/features/auth/screens/auth_screen.dart';
import 'package:shop_proh/features/auth/screens/forgotpass_screen.dart';
import 'package:shop_proh/features/auth/screens/otp_screen.dart';
import 'package:shop_proh/features/auth/screens/register_screen.dart';
import 'package:shop_proh/features/auth/screens/resetpassword_screen.dart';
import 'package:shop_proh/features/cart/services/cart_services.dart';
import 'package:shop_proh/features/order_details/screens/order_details.dart';
import 'package:shop_proh/features/product_details/screens/product_details_screen%20copy.dart';
import 'package:shop_proh/features/product_details/screens/product_details_screen.dart';
import 'package:shop_proh/features/search/screens/search_screens.dart';
import 'package:shop_proh/home/screens/all_products_screen.dart';
import 'package:shop_proh/home/screens/category_deals_screen.dart';
import 'package:shop_proh/home/screens/chat_screen.dart';
import 'package:shop_proh/home/screens/home_screen.dart';
import 'package:shop_proh/models/category.dart';
import 'package:shop_proh/models/order.dart';
import 'package:shop_proh/models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );
    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPasswordScreen(),
      );
    case OtpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OtpScreen(),
      );
    case ResetPassWordScreen.routeName:
      var email = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ResetPassWordScreen(
          email: email,
        ),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddCategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddCategoryScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AllProductsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AllProductsScreen(),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case UpdateCategoryScreen.routeName:
      var category = routeSettings.arguments as Category;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateCategoryScreen(
          category: category,
        ),
      );
    case UpdateProductScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => UpdateProductScreen(
          product: product,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case ChatScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChatScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      );
  }
}
