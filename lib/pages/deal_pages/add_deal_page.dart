// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/deal_models/deal_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/product_models/product_model.dart' as product_model;
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_button.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_textfield.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AddDealPage extends StatefulWidget {
  final DealData? dealData;
  const AddDealPage({Key? key, this.dealData}) : super(key: key);

  @override
  State<AddDealPage> createState() => _AddDealPageState();
}

class _AddDealPageState extends State<AddDealPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  String? vendorId;
  bool isLoading = false;
  bool isActive = true;
  bool isFeatured = false;

  final TextEditingController dealTitleController = TextEditingController();
  final TextEditingController dealDescriptionController = TextEditingController();
  final TextEditingController originalPriceController = TextEditingController();
  final TextEditingController dealPriceController = TextEditingController();
  final TextEditingController discountPercentageController = TextEditingController();
  final TextEditingController availableQuantityController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  List<product_model.Product> products = [];
  String? selectedProductId;
  String? selectedProductName;

  @override
  void initState() {
    super.initState();
    loadVendorId();
    loadProducts();
    if (widget.dealData != null) {
      loadDealData();
    }
  }

  Future<void> loadVendorId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
  }

  Future<void> loadProducts() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      vendorId = pref.getString(vendorIdPreference);

      var map = {"vendor_id": vendorId};
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.productsApi, data: map);

      if (response.statusCode == 200) {
        product_model.ProductModel productModel = product_model.ProductModel.fromJson(response.data);
        if (productModel.status.toString() == "1" && productModel.data != null) {
          setState(() {
            products = productModel.data ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading products: $e");
    }
  }

  void loadDealData() {
    dealTitleController.text = widget.dealData!.dealTitle ?? "";
    dealDescriptionController.text = widget.dealData!.dealDescription ?? "";
    originalPriceController.text = widget.dealData!.originalPrice?.toString() ?? "";
    dealPriceController.text = widget.dealData!.dealPrice?.toString() ?? "";
    discountPercentageController.text = widget.dealData!.discountPercentage?.toString() ?? "";
    availableQuantityController.text = widget.dealData!.availableQuantity?.toString() ?? "";
    startDateController.text = widget.dealData!.startDate ?? "";
    endDateController.text = widget.dealData!.endDate ?? "";
    selectedProductId = widget.dealData!.productId;
    selectedProductName = widget.dealData!.productName;
    isActive = widget.dealData!.status == "1";
    isFeatured = widget.dealData!.featured == "1";
  }

  void calculateDiscount() {
    if (originalPriceController.text.isNotEmpty && dealPriceController.text.isNotEmpty) {
      double originalPrice = double.parse(originalPriceController.text);
      double dealPrice = double.parse(dealPriceController.text);
      if (originalPrice > 0) {
        double discount = ((originalPrice - dealPrice) / originalPrice) * 100;
        discountPercentageController.text = discount.toStringAsFixed(0);
      }
    }
  }

  Future<void> selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> saveDeal() async {
    if (selectedProductId == null) {
      DialogBox.dialogBoxControl(description: "str_please_select_product".tr);
      return;
    }
    if (dealPriceController.text.isEmpty) {
      DialogBox.dialogBoxControl(description: "str_please_enter_deal_price".tr);
      return;
    }

    setState(() => isLoading = true);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => isLoading = false);
        DialogBox.dialogBoxControl(
          description: widget.dealData != null
              ? "str_deal_updated".tr
              : "str_deal_added".tr,
        );
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        setState(() => isLoading = false);
        DialogBox.dialogBoxControl(description: "Error: $e");
      }
      return;
    }

    // Real API call
    try {
      var map = {
        "vendor_id": vendorId,
        "product_id": selectedProductId,
        "deal_title": dealTitleController.text,
        "deal_description": dealDescriptionController.text,
        "original_price": originalPriceController.text,
        "deal_price": dealPriceController.text,
        "discount_percentage": discountPercentageController.text,
        "available_quantity": availableQuantityController.text,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "status": isActive ? "1" : "0",
        "featured": isFeatured ? "1" : "0",
      };

      if (widget.dealData != null) {
        map["deal_id"] = widget.dealData!.id!;
      }

      String apiUrl = widget.dealData != null
          ? DefaultApi.apiUrl + PostApi.updateDealApi
          : DefaultApi.apiUrl + PostApi.addDealApi;

      var response = await Dio().post(apiUrl, data: map);

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['status'].toString() == "1") {
          DialogBox.dialogBoxControl(
            description: widget.dealData != null
                ? "str_deal_updated".tr
                : "str_deal_added".tr,
          );
          Navigator.pop(context, true);
        } else {
          DialogBox.dialogBoxControl(description: responseData['message'].toString());
        }
      } else {
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: FashionHubColors.lightPrimaryColor,
        backgroundColor: FashionHubColors.lightPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.dealData != null ? "str_edit_deal".tr : "str_add_deal".tr,
          style: boldFont.copyWith(fontSize: 20.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width / 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "str_select_product".tr,
                style: mediumFont.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: height / 100),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: FashionHubColors.greyColor),
                ),
                padding: EdgeInsets.symmetric(horizontal: width / 36),
                child: DropdownButton<String>(
                  value: selectedProductId,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: Text(
                    "str_select_product".tr,
                    style: regularFont.copyWith(fontSize: 12.sp),
                  ),
                  items: products.map((product) {
                    return DropdownMenuItem<String>(
                      value: product.id ?? '',
                      child: Text(
                        product.name ?? "",
                        style: regularFont.copyWith(fontSize: 12.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProductId = value;
                      if (value != null) {
                        var product = products.firstWhere((p) => p.id == value);
                        selectedProductName = product.name;
                        originalPriceController.text = product.price?.toString() ?? "";
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: dealTitleController,
                hintText: "str_enter_deal_title".tr,
                labelText: "str_deal_title".tr,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: dealDescriptionController,
                hintText: "str_enter_deal_description".tr,
                labelText: "str_deal_description".tr,
                maxLines: 3,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: originalPriceController,
                hintText: "str_enter_original_price".tr,
                labelText: "str_original_price".tr,
                keyboardType: TextInputType.number,
                onChanged: (value) => calculateDiscount(),
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: dealPriceController,
                hintText: "str_enter_deal_price".tr,
                labelText: "str_deal_price".tr,
                keyboardType: TextInputType.number,
                onChanged: (value) => calculateDiscount(),
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: discountPercentageController,
                hintText: "str_discount_percentage".tr,
                labelText: "str_discount_percentage".tr,
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: availableQuantityController,
                hintText: "str_enter_quantity".tr,
                labelText: "str_available_quantity".tr,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: startDateController,
                hintText: "str_select_start_date".tr,
                labelText: "str_start_date".tr,
                readOnly: true,
                onTap: () => selectDate(startDateController),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: endDateController,
                hintText: "str_select_end_date".tr,
                labelText: "str_end_date".tr,
                readOnly: true,
                onTap: () => selectDate(endDateController),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              SizedBox(height: height / 46),
              Row(
                children: [
                  Text(
                    "str_featured".tr,
                    style: mediumFont.copyWith(fontSize: 12.sp),
                  ),
                  const Spacer(),
                  Switch(
                    value: isFeatured,
                    onChanged: (value) {
                      setState(() {
                        isFeatured = value;
                      });
                    },
                    activeColor: FashionHubColors.primaryColor,
                  ),
                  Text(
                    isFeatured ? "str_yes".tr : "str_no".tr,
                    style: mediumFont.copyWith(
                      fontSize: 12.sp,
                      color: isFeatured ? FashionHubColors.primaryColor : FashionHubColors.greyColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 66),
              Row(
                children: [
                  Text(
                    "str_status".tr,
                    style: mediumFont.copyWith(fontSize: 12.sp),
                  ),
                  const Spacer(),
                  Switch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                    activeColor: FashionHubColors.greenColor,
                  ),
                  Text(
                    isActive ? "str_active".tr : "str_inactive".tr,
                    style: mediumFont.copyWith(
                      fontSize: 12.sp,
                      color: isActive ? FashionHubColors.greenColor : FashionHubColors.greyColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 26),
              CustomButton(
                text: widget.dealData != null ? "str_update_deal".tr : "str_add_deal".tr,
                isLoading: isLoading,
                onPressed: saveDeal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dealTitleController.dispose();
    dealDescriptionController.dispose();
    originalPriceController.dispose();
    dealPriceController.dispose();
    discountPercentageController.dispose();
    availableQuantityController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
