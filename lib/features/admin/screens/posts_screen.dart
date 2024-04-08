import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/loader.dart';
import 'package:shop_proh/features/account/widgets/single_product.dart';
import 'package:shop_proh/features/admin/screens/add_product_screen.dart';
import 'package:shop_proh/features/admin/screens/update_product_screen.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/features/product_details/screens/product_details_screen%20copy.dart';
import 'package:shop_proh/features/product_details/screens/product_details_screen.dart';
import 'package:shop_proh/models/product.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        setState(() {
          products!.removeAt(index);
        });
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  void navigateToProductDetail(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  void navigateToUpdateProduct(Product product) {
    Navigator.pushNamed(
      context,
      UpdateProductScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Danh sách sản phẩm'),
      ),
      body: products == null
          ? const Loader()
          : ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: products!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return Card(
                      elevation: 3.0,
                      child: InkWell(
                        onTap: () {
                          navigateToProductDetail(productData);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 140,
                              child: SingleProduct(
                                image: productData.images[0],
                                onEdit: () {
                                  navigateToUpdateProduct(productData);
                                },
                                onDelete: () {
                                  deleteProduct(productData, index);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                productData.name!,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: navigateToAddProduct,
        tooltip: 'Thêm sản phẩm',
      ),
    );
  }
}
