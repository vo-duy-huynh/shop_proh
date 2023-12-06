import 'package:flutter/material.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/home/screens/category_deals_screen.dart';
import 'package:shop_proh/home/services/home_services.dart';
import 'package:shop_proh/models/category.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  String selected = '';
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchAllCategories();
    selected = 'All';
  }

  @override
  void dispose() {
    super.dispose();
    listCategory.clear();
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  List<Category> listCategory = [];
  void fetchAllCategories() async {
    listCategory = await homeServices.fetchAllCategories(context: context);
    listCategory.insert(0, Category(name: 'All'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(children: [
            for (int i = 0; i < listCategory.length; i++)
              InkWell(
                onTap: () => navigateToCategoryPage(
                    context, listCategory[i].name.toLowerCase()),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // nếu đang chọn thì màu sẽ là màu 0xFFFD725A, còn không thì màu sẽ là màu đen
                    color: selected == listCategory[i].name
                        ? const Color(0xFFFD725A)
                        : Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        listCategory[i].name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
        ));
  }
}
