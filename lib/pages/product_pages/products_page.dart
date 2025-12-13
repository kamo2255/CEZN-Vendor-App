import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/product_models/product_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/product_pages/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductsController controller = Get.put(ProductsController());

  @override
  void initState() {
    super.initState();
    controller.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FashionHubColors.lightGreyColor,
      appBar: AppBar(
        backgroundColor: FashionHubColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "str_products".tr,
          style: TextStyle(
            fontFamily: "OpenSansBold",
            fontSize: 14.sp,
            color: FashionHubColors.whiteColor,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 2.h),
                Text(
                  "str_no_products_found".tr,
                  style: TextStyle(
                    fontFamily: "OpenSansMedium",
                    fontSize: 12.sp,
                    color: FashionHubColors.greyColor,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getProducts(),
          child: ListView.builder(
            padding: EdgeInsets.all(2.h),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Get.to(() => AddProductPage(product: product));
                },
                onDelete: () {
                  controller.deleteProduct(product.id);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddProductPage());
        },
        backgroundColor: FashionHubColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.image != null && product.image.toString().isNotEmpty
                    ? Image.network(
                        product.image.toString(),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image, color: Colors.grey.shade400),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade200,
                        child: Icon(Icons.image, color: Colors.grey.shade400),
                      ),
              ),
              SizedBox(width: 2.w),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      style: TextStyle(
                        fontFamily: "OpenSansBold",
                        fontSize: 11.sp,
                        color: FashionHubColors.blackColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    if (product.categoryName != null)
                      Text(
                        product.categoryName.toString(),
                        style: TextStyle(
                          fontFamily: "OpenSansRegular",
                          fontSize: 9.sp,
                          color: FashionHubColors.greyColor,
                        ),
                      ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Text(
                          '\$${product.price ?? '0'}',
                          style: TextStyle(
                            fontFamily: "OpenSansBold",
                            fontSize: 11.sp,
                            color: FashionHubColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        if (product.stock != null)
                          Text(
                            '${"str_stock".tr}: ${product.stock}',
                            style: TextStyle(
                              fontFamily: "OpenSansRegular",
                              fontSize: 9.sp,
                              color: FashionHubColors.greyColor,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: product.status == '1'
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        product.status == '1' ? "str_active".tr : "str_inactive".tr,
                        style: TextStyle(
                          fontFamily: "OpenSansMedium",
                          fontSize: 8.sp,
                          color: product.status == '1' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Delete Button
              IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "str_delete_product".tr,
                    middleText: "str_delete_product_confirm".tr,
                    textConfirm: "str_yes".tr,
                    textCancel: "str_no".tr,
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      onDelete();
                    },
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsController extends GetxController {
  var isLoading = false.obs;
  var products = <Product>[].obs;

  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      var response = await Dio().post(
        DefaultApi.apiUrl + PostApi.productsApi,
        data: {},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        ProductModel productModel = ProductModel.fromJson(response.data);
        products.value = productModel.data ?? [];
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

  Future<void> deleteProduct(dynamic productId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      var response = await Dio().post(
        DefaultApi.apiUrl + PostApi.deleteProductApi,
        data: {'product_id': productId},
      );

      Get.back();

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        products.removeWhere((p) => p.id == productId);
        Get.snackbar(
          "str_success".tr,
          response.data['message'] ?? "str_product_deleted".tr,
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
      Get.back();
      Get.snackbar(
        "str_error".tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
