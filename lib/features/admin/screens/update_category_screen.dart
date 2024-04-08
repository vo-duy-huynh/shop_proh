import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shop_proh/common/widgets/custom_textfield.dart';
import 'package:shop_proh/constants/ultils.dart';
import 'package:shop_proh/features/admin/services/admin_services.dart';
import 'package:shop_proh/models/category.dart';

class UpdateCategoryScreen extends StatefulWidget {
  static const String routeName = '/update-category';

  final Category category;

  const UpdateCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final AdminServices adminServices = AdminServices();
  File? updatedImage;
  bool useOldImage = true;
  String? oldImage;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category.name;
    descriptionController.text = widget.category.description ?? '';
  }

  void updateCategory() {
    adminServices.updateCategory(
      context: context,
      category: widget.category,
      name: nameController.text,
      description: descriptionController.text,
      imageCover: useOldImage ? null : updatedImage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  void selectUpdatedImage() async {
    var res = await pickImage();
    setState(() {
      updatedImage = res;
      useOldImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Category category = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập Nhật Danh Mục'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: updateCategory,
            tooltip: 'Cập Nhật',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectUpdatedImage,
                child: useOldImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          category.imageCover!,
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          updatedImage!,
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                      ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                hintText: 'Tên Danh Mục',
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Mô Tả',
                maxLines: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
