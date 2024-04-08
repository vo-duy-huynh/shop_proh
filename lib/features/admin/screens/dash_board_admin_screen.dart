import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_proh/features/account/widgets/orders.dart';
import 'package:shop_proh/features/admin/screens/add_category_screen.dart';
import 'package:shop_proh/features/admin/screens/admin_categories_screen.dart';
import 'package:shop_proh/features/admin/screens/orders_screen.dart';
import 'package:shop_proh/features/admin/screens/posts_screen.dart';
import 'package:shop_proh/features/auth/services/auth_service.dart';

class DashBoardAdminScreen extends StatefulWidget {
  const DashBoardAdminScreen({super.key});

  @override
  State<DashBoardAdminScreen> createState() => _DashBoardAdminScreenState();
}

class _DashBoardAdminScreenState extends State<DashBoardAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    AuthService().logOut(context);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text(
                      'Hello Admin!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    trailing: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        CupertinoIcons.person_alt,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to CategoryScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AdminCategoriesScreen()),
                      );
                    },
                    child: itemDashboard(
                      'Categories',
                      CupertinoIcons.square_grid_2x2,
                      Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostsScreen()),
                      );
                    },
                    child: itemDashboard(
                      'Products',
                      CupertinoIcons.square_grid_2x2_fill,
                      Colors.orange,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrdersScreen()),
                      );
                    },
                    child: itemDashboard(
                        'Orders', CupertinoIcons.cart, Colors.green),
                  ),
                  itemDashboard('Users', CupertinoIcons.person_2, Colors.red),
                  itemDashboard(
                      'Charts', CupertinoIcons.chart_bar_square, Colors.purple),
                  itemDashboard(
                      'Settings', CupertinoIcons.settings, Colors.blue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(title.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      );
}
