import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/custom_button.dart';
import 'package:shop_proh/common/widgets/custom_textfield.dart';
import 'package:shop_proh/constants/globalvariable.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName = '/add-category';
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptonController = TextEditingController();
  final AdminServices adminServices = AdminServices();

  final _addCategoryFormKey = GlobalKey<FormState>();
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptonController.dispose();
  }

  void sellCategory() async {
    if (_addCategoryFormKey.currentState!.validate()) {
      adminServices.sellCategory(
        context: context,
        name: nameController.text,
        description: descriptonController.text,
        imageCover: image!,
      );
    }
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      image = res;
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
          title: const Text(
            'Thêm Danh Mục',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addCategoryFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                image != null
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {},
                        ),
                        items: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: selectImage,
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
                  controller: nameController,
                  hintText: 'Tên Danh Mục',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptonController,
                  hintText: 'Mô Tả',
                  maxLines: 7,
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Thêm Danh Mục',
                  onTap: sellCategory,
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
