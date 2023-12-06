import 'package:flutter/material.dart';
import 'package:shop_proh/home/screens/category_deals_screen.dart';
import 'package:shop_proh/home/services/home_services.dart';
import 'package:shop_proh/models/category.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories> {
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchTopCategories();
  }

  @override
  void dispose() {
    super.dispose();
    listCategory.clear();
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryDealsScreen.routeName,
      arguments: category,
    );
  }

  List<Category> listCategory = [];
  void fetchTopCategories() async {
    listCategory = await homeServices.fetchTop6Categories(context: context);
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
                    context, listCategory[i].id.toString()),
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set your desired border radius
                                border: Border.all(
                                  color: Colors.white, // Set the border color
                                  width: 1.0, // Set the border width
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  listCategory[i].imageCover!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        listCategory[i].name,
                        style: const TextStyle(
                          fontSize: 12,
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
