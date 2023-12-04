import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/loader.dart';
import 'package:shop_proh/features/admin/screens/add_category_screen.dart';
import 'package:shop_proh/features/admin/screens/update_category_screen.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/models/category.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<Category>? categories;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  fetchAllCategories() async {
    categories = await adminServices.fetchAllCategories(context);
    setState(() {});
  }

  void deleteCategory(Category category, int index) {
    adminServices.deleteCategory(
      context: context,
      category: category,
      onSuccess: () {
        categories!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddCategory() {
    Navigator.pushNamed(context, AddCategoryScreen.routeName);
  }

  void navigateToUpdateCategory(Category category) {
    Navigator.pushNamed(
      context,
      UpdateCategoryScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Mục Sản Phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddCategory,
            tooltip: 'Thêm Danh Mục',
          ),
        ],
      ),
      body: categories == null
          ? const Center(child: Loader())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: categories!.length,
              itemBuilder: (context, index) {
                final categoryData = categories![index];
                return GestureDetector(
                  onTap: () {
                    navigateToUpdateCategory(categoryData);
                  },
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                            child: Image.network(
                              categoryData.imageCover!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categoryData.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  deleteCategory(categoryData, index),
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
