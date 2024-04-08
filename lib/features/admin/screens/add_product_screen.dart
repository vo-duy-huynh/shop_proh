import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/custom_button.dart';
import 'package:shop_proh/common/widgets/custom_textfield.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/models/category.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptonController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  String? selectedValue;
  final _addProductFormKey = GlobalKey<FormState>();
  List<File> images = [];
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptonController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchAllCategories();
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      if (selectedValue != null) {
        adminServices.sellProduct(
          context: context,
          name: productNameController.text,
          description: descriptonController.text,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          images: images,
          categoryId: selectedValue!,
        );
      }
    }
  }

  List<Category> listCategory = [];
  void fetchAllCategories() async {
    listCategory = await adminServices.fetchAllCategories(context);
    setState(() {});
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          backgroundColor: Colors.blue,
          title: const Text(
            'Thêm Sản Phẩm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map((i) {
                          return Builder(
                            builder: (BuildContext context) => Image.file(
                              i,
                              fit: BoxFit.cover,
                              height: 200,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Thêm hình ảnh',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Tên Sản Phẩm',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptonController,
                  hintText: 'Mô Tả',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Giá',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Số Lượng',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    hint: const Text('Chọn Danh Mục'),
                    value: selectedValue,
                    items: listCategory
                        .map((e) => DropdownMenuItem(
                              child: Text(e.name),
                              value: e.id,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String?;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Thêm Sản Phẩm',
                  onTap: sellProduct,
                  color: GlobalVariables.appBarGradient.colors[0],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
