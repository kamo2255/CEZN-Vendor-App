import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/product_models/category_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/product_models/product_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_button.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;

  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final AddProductController controller = Get.put(AddProductController());

  @override
  void initState() {
    super.initState();
    controller.getCategories();
    if (widget.product != null) {
      controller.initializeProduct(widget.product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FashionHubColors.lightGreyColor,
      appBar: AppBar(
        backgroundColor: FashionHubColors.primaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          widget.product != null ? "str_edit_product".tr : "str_add_product".tr,
          style: TextStyle(
            fontFamily: "OpenSansBold",
            fontSize: 14.sp,
            color: FashionHubColors.whiteColor,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Obx(() {
                      if (controller.selectedImage.value != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(controller.selectedImage.value!),
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (controller.productImage.value.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            controller.productImage.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          ),
                        );
                      } else {
                        return _buildImagePlaceholder();
                      }
                    }),
                  ),
                ),
              ),
              SizedBox(height: 3.h),

              // Product Name
              _buildLabel("str_product_name".tr),
              SizedBox(height: 1.h),
              CustomTextField(
                hintText: "str_enter_product_name".tr,
                controller: controller.nameController,
              ),
              SizedBox(height: 2.h),

              // Description
              _buildLabel("str_description".tr),
              SizedBox(height: 1.h),
              CustomTextField(
                hintText: "str_enter_description".tr,
                controller: controller.descriptionController,
                maxLines: 4,
              ),
              SizedBox(height: 2.h),

              // Category Dropdown
              _buildLabel("str_category".tr),
              SizedBox(height: 1.h),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedCategory.value.isEmpty
                            ? null
                            : controller.selectedCategory.value,
                        hint: Text(
                          "str_select_category".tr,
                          style: TextStyle(
                            fontFamily: "OpenSansRegular",
                            fontSize: 10.sp,
                            color: FashionHubColors.greyColor,
                          ),
                        ),
                        items: controller.categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.id.toString(),
                            child: Text(
                              category.name ?? '',
                              style: TextStyle(
                                fontFamily: "OpenSansRegular",
                                fontSize: 10.sp,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedCategory.value = value;
                          }
                        },
                      ),
                    ),
                  )),
              SizedBox(height: 2.h),

              // Price and Stock Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("str_price".tr),
                        SizedBox(height: 1.h),
                        CustomTextField(
                          hintText: "str_enter_price".tr,
                          controller: controller.priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("str_stock".tr),
                        SizedBox(height: 1.h),
                        CustomTextField(
                          hintText: "str_enter_stock".tr,
                          controller: controller.stockController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // SKU
              _buildLabel("str_sku".tr),
              SizedBox(height: 1.h),
              CustomTextField(
                hintText: "str_enter_sku".tr,
                controller: controller.skuController,
              ),
              SizedBox(height: 2.h),

              // Status Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("str_status".tr),
                  Obx(() => Switch(
                        value: controller.isActive.value,
                        onChanged: (value) {
                          controller.isActive.value = value;
                        },
                        activeTrackColor: FashionHubColors.primaryColor,
                      )),
                ],
              ),
              SizedBox(height: 3.h),

              // Submit Button
              Obx(() => CustomButton(
                    buttonText: widget.product != null
                        ? "str_update_product".tr
                        : "str_add_product".tr,
                    onTap: () {
                      if (widget.product != null) {
                        controller.updateProduct(widget.product!.id);
                      } else {
                        controller.addProduct();
                      }
                    },
                    loading: controller.isLoading.value,
                  )),
              SizedBox(height: 2.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "OpenSansMedium",
        fontSize: 10.sp,
        color: FashionHubColors.blackColor,
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade600),
        SizedBox(height: 1.h),
        Text(
          "str_add_image".tr,
          style: TextStyle(
            fontFamily: "OpenSansRegular",
            fontSize: 10.sp,
            color: FashionHubColors.greyColor,
          ),
        ),
      ],
    );
  }
}

class AddProductController extends GetxController {
  var isLoading = false.obs;
  var isLoadingCategories = false.obs;
  var selectedImage = Rxn<String>();
  var productImage = ''.obs;
  var selectedCategory = ''.obs;
  var isActive = true.obs;
  var categories = <Category>[].obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final skuController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  void initializeProduct(Product product) {
    nameController.text = product.name ?? '';
    descriptionController.text = product.description ?? '';
    priceController.text = product.price?.toString() ?? '';
    stockController.text = product.stock?.toString() ?? '';
    skuController.text = product.sku ?? '';
    selectedCategory.value = product.categoryId?.toString() ?? '';
    isActive.value = product.status == '1';
    productImage.value = product.image ?? '';
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        "str_error".tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getCategories() async {
    try {
      isLoadingCategories.value = true;
      var response = await dio.Dio().post(
        DefaultApi.apiUrl + PostApi.categoriesApi,
        data: {},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        CategoryModel categoryModel = CategoryModel.fromJson(response.data);
        categories.value = categoryModel.data ?? [];
      }
    } catch (e) {
      Get.snackbar(
        "str_error".tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> addProduct() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      dio.FormData formData;
      if (selectedImage.value != null) {
        formData = dio.FormData.fromMap({
          'name': nameController.text,
          'description': descriptionController.text,
          'category_id': selectedCategory.value,
          'price': priceController.text,
          'stock': stockController.text,
          'sku': skuController.text,
          'status': isActive.value ? '1' : '0',
          'image': await dio.MultipartFile.fromFile(
            selectedImage.value!,
            filename: selectedImage.value!.split("/").last,
          ),
        });
      } else {
        formData = dio.FormData.fromMap({
          'name': nameController.text,
          'description': descriptionController.text,
          'category_id': selectedCategory.value,
          'price': priceController.text,
          'stock': stockController.text,
          'sku': skuController.text,
          'status': isActive.value ? '1' : '0',
        });
      }

      var response = await dio.Dio().post(
        DefaultApi.apiUrl + PostApi.addProductApi,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        Get.back();
        Get.snackbar(
          "str_success".tr,
          response.data['message'] ?? "str_product_added".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "str_error".tr,
          response.data['message'] ?? "str_something_wrong".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "str_error".tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(dynamic productId) async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      dio.FormData formData;
      if (selectedImage.value != null) {
        formData = dio.FormData.fromMap({
          'product_id': productId,
          'name': nameController.text,
          'description': descriptionController.text,
          'category_id': selectedCategory.value,
          'price': priceController.text,
          'stock': stockController.text,
          'sku': skuController.text,
          'status': isActive.value ? '1' : '0',
          'image': await dio.MultipartFile.fromFile(
            selectedImage.value!,
            filename: selectedImage.value!.split("/").last,
          ),
        });
      } else {
        formData = dio.FormData.fromMap({
          'product_id': productId,
          'name': nameController.text,
          'description': descriptionController.text,
          'category_id': selectedCategory.value,
          'price': priceController.text,
          'stock': stockController.text,
          'sku': skuController.text,
          'status': isActive.value ? '1' : '0',
        });
      }

      var response = await dio.Dio().post(
        DefaultApi.apiUrl + PostApi.updateProductApi,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        Get.back();
        Get.snackbar(
          "str_success".tr,
          response.data['message'] ?? "str_product_updated".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "str_error".tr,
          response.data['message'] ?? "str_something_wrong".tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "str_error".tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        "str_error".tr,
        "str_please_enter_product_name".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        "str_error".tr,
        "str_please_select_category".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (priceController.text.isEmpty) {
      Get.snackbar(
        "str_error".tr,
        "str_please_enter_price".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    skuController.dispose();
    super.onClose();
  }
}
