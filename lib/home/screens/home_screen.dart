import 'package:flutter/material.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/features/search/screens/search_screens.dart';
import 'package:shop_proh/home/screens/category_deals_screen.dart';
import 'package:shop_proh/home/services/home_services.dart';
import 'package:shop_proh/home/widgets/deal_of_day.dart';
import 'package:shop_proh/home/widgets/top_categories.dart';
import 'package:shop_proh/models/category.dart';
import 'package:shop_proh/models/product.dart';
import 'package:shop_proh/home/widgets/carousel_image.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  String selected = '';
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchAllCategories();
    selected = 'All';
    fetchCategoryProducts(selected);
  }

  @override
  void dispose() {
    super.dispose();
    listCategory.clear();
  }

  void updateSelectedCategory(String category) {
    setState(() {
      selected = category;
    });
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  List<Category> listCategory = [];
  void fetchAllCategories() async {
    listCategory = await homeServices.fetchAllCategories(context: context);
    listCategory.insert(0, Category(name: 'All', id: 'All'));
    setState(() {});
  }

  List<Product> listProduct = [];
  void fetchCategoryProducts(String category) async {
    listProduct = await homeServices.fetchByCategory(
      context: context,
      categoryId: category == 'All' ? 'All' : category,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Bạn tìm gì hôm nay?',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            const TopCategories(),
            const SizedBox(height: 10),
            const CarouselImage(),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(children: [
                  for (int i = 0; i < listCategory.length; i++)
                    InkWell(
                      onTap: () => {
                        fetchCategoryProducts(listCategory[i].id.toString()),
                        updateSelectedCategory(listCategory[i].id.toString()),
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selected == listCategory[i].id.toString()
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
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (screenWidth - 30 - 15) / (2 * 290),
                mainAxisSpacing: 45,
                crossAxisSpacing: 15,
              ),
              itemCount: listProduct.length > 0
                  ? listProduct.length
                  : 1, // Kiểm tra danh sách có trống hay không
              itemBuilder: (_, i) {
                if (listProduct.isEmpty) {
                  return const Center(
                    child: Text('Không có sản phẩm nào'),
                  );
                }

                if (i % 2 == 0) {
                  return DealOfDay(
                    product: listProduct[i],
                  );
                }

                return OverflowBox(
                  maxHeight: 290.0 + 70.0,
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: DealOfDay(
                      product: listProduct[i],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
