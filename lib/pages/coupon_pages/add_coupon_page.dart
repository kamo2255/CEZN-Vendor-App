// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/coupon_models/coupon_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_button.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/custom_textfield.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class AddCouponPage extends StatefulWidget {
  final CouponData? couponData;
  const AddCouponPage({Key? key, this.couponData}) : super(key: key);

  @override
  State<AddCouponPage> createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  String? vendorId;
  bool isLoading = false;
  bool isActive = true;

  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController discountValueController = TextEditingController();
  final TextEditingController minOrderController = TextEditingController();
  final TextEditingController maxDiscountController = TextEditingController();
  final TextEditingController usageLimitController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String selectedDiscountType = "percentage";
  List<String> discountTypes = ["percentage", "fixed"];

  @override
  void initState() {
    super.initState();
    loadVendorId();
    if (widget.couponData != null) {
      loadCouponData();
    }
  }

  Future<void> loadVendorId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
  }

  void loadCouponData() {
    codeController.text = widget.couponData!.code ?? "";
    descriptionController.text = widget.couponData!.description ?? "";
    discountValueController.text = widget.couponData!.discountValue?.toString() ?? "";
    minOrderController.text = widget.couponData!.minOrderAmount?.toString() ?? "";
    maxDiscountController.text = widget.couponData!.maxDiscountAmount?.toString() ?? "";
    usageLimitController.text = widget.couponData!.usageLimit?.toString() ?? "";
    startDateController.text = widget.couponData!.startDate ?? "";
    endDateController.text = widget.couponData!.endDate ?? "";
    selectedDiscountType = widget.couponData!.discountType ?? "percentage";
    isActive = widget.couponData!.status == "1";
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

  Future<void> saveCoupon() async {
    if (codeController.text.isEmpty) {
      DialogBox.dialogBoxControl(description: "str_please_enter_coupon_code".tr);
      return;
    }
    if (discountValueController.text.isEmpty) {
      DialogBox.dialogBoxControl(description: "str_please_enter_discount_value".tr);
      return;
    }

    setState(() => isLoading = true);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => isLoading = false);
        DialogBox.dialogBoxControl(
          description: widget.couponData != null
              ? "str_coupon_updated".tr
              : "str_coupon_added".tr,
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
        "code": codeController.text,
        "description": descriptionController.text,
        "discount_type": selectedDiscountType,
        "discount_value": discountValueController.text,
        "min_order_amount": minOrderController.text,
        "max_discount_amount": maxDiscountController.text,
        "usage_limit": usageLimitController.text,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "status": isActive ? "1" : "0",
      };

      if (widget.couponData != null) {
        map["coupon_id"] = widget.couponData!.id!;
      }

      String apiUrl = widget.couponData != null
          ? DefaultApi.apiUrl + PostApi.updateCouponApi
          : DefaultApi.apiUrl + PostApi.addCouponApi;

      var response = await Dio().post(apiUrl, data: map);

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['status'].toString() == "1") {
          DialogBox.dialogBoxControl(
            description: widget.couponData != null
                ? "str_coupon_updated".tr
                : "str_coupon_added".tr,
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
          widget.couponData != null ? "str_edit_coupon".tr : "str_add_coupon".tr,
          style: boldFont.copyWith(fontSize: 20.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width / 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: codeController,
                hintText: "str_enter_coupon_code".tr,
                labelText: "str_coupon_code".tr,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: descriptionController,
                hintText: "str_enter_description".tr,
                labelText: "str_description".tr,
                maxLines: 3,
              ),
              SizedBox(height: height / 46),
              Text(
                "str_discount_type".tr,
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
                  value: selectedDiscountType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: discountTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type == "percentage" ? "str_percentage".tr : "str_fixed_amount".tr,
                        style: regularFont.copyWith(fontSize: 12.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDiscountType = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: discountValueController,
                hintText: "str_enter_discount_value".tr,
                labelText: "str_discount_value".tr,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: minOrderController,
                hintText: "str_enter_min_order".tr,
                labelText: "str_min_order_amount".tr,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: maxDiscountController,
                hintText: "str_enter_max_discount".tr,
                labelText: "str_max_discount_amount".tr,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: height / 46),
              CustomTextField(
                controller: usageLimitController,
                hintText: "str_enter_usage_limit".tr,
                labelText: "str_usage_limit".tr,
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
                text: widget.couponData != null ? "str_update_coupon".tr : "str_add_coupon".tr,
                isLoading: isLoading,
                onPressed: saveCoupon,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    descriptionController.dispose();
    discountValueController.dispose();
    minOrderController.dispose();
    maxDiscountController.dispose();
    usageLimitController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
