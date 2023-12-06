import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/custom_textfield.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/models/product.dart';
import 'package:shop_proh/models/category.dart';

class UpdateProductScreen extends StatefulWidget {
  static const String routeName = '/update-product';

  final Product product;
  const UpdateProductScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  String? selectedValue;
  List<File> images = [];
  bool useOldImage = true;
  List<String> oldImages = [];

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description ?? '';
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
    selectedValue = widget.product.category;
    oldImages = widget.product.images!;
    fetchAllCategories();
  }

  void updateProduct() {
    adminServices.updateProduct(
      context: context,
      product: widget.product,
      name: nameController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      quantity: double.parse(quantityController.text),
      images: images,
      categoryId: selectedValue!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  List<Category> listCategory = [];
  void fetchAllCategories() async {
    listCategory = await adminServices.fetchAllCategories(context);
    setState(() {});
  }

  void selectUpdatedImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập Nhật Sản Phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: updateProduct,
            tooltip: 'Cập Nhật',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              (images.isNotEmpty || oldImages.isNotEmpty)
                  ? GestureDetector(
                      onTap: selectUpdatedImages,
                      child: CarouselSlider(
                        items: [
                          ...oldImages.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) =>
                                    Image.network(
                                  i,
                                  fit: BoxFit.contain,
                                  height: 200,
                                ),
                              );
                            },
                          ),
                          ...images.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) => Image.file(
                                  i,
                                  fit: BoxFit.contain,
                                  height: 200,
                                ),
                              );
                            },
                          ),
                        ],
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 300,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: selectUpdatedImages,
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
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                hintText: 'Tên Danh Mục',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Mô Tả',
                maxLines: 7,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: priceController,
                hintText: 'Giá Bán',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: quantityController,
                hintText: 'Số Lượng',
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: DropdownButton<String>(
                  value: selectedValue,
                  hint: const Text('Chọn Danh Mục'),
                  isExpanded: true,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  items: listCategory.map((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
