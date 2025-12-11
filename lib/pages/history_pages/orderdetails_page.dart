// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use, must_be_immutable, use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/history_models/orderdetails_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/history_models/statusupdate_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/validation/validation.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatefulWidget {
  String? orderNumber;
  String? statusType;
  String? paymentStatus;

  OrderDetailsPage(this.orderNumber, this.statusType, this.paymentStatus,
      {super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.put(ThemeController());
  OrderDetailsModel? responseData;
  StatusUpdateModel? statusData;
  String? vendorId;
  String? statusId;
  String? statusType;
  String? paymentStatus;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;
  double? _progress;
  bool isCome = false;
  List<String> taxName = [];
  List<dynamic> taxPrice = [];
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtLandmark = TextEditingController();
  TextEditingController txtPinCode = TextEditingController();
  TextEditingController txtCity = TextEditingController();
  TextEditingController txtState = TextEditingController();
  TextEditingController txtCountry = TextEditingController();
  TextEditingController txtVendorNotes = TextEditingController();

  @override
  void initState() {
    super.initState();
    statusType = widget.statusType;
    paymentStatus = widget.paymentStatus;
  }

  Future orderDetailsAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    currency = pref.getString(currencyPreference);
    currencyPosition = pref.getString(currencyPositionPreference);
    currencySpace = pref.getInt(currencySpacePreference);
    decimalSeparator = pref.getInt(decimalSeparatorPreference);
    currencyFormat = pref.getInt(currencyFormatPreference);
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "order_number": widget.orderNumber
      };
      debugPrint("$map");
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.orderDetailsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        isCome = true;
        responseData = OrderDetailsModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          if (responseData!.data!.taxName != "" &&
              responseData!.data!.taxName != null && responseData!.data!.taxName != "null" && responseData!.data!.taxAmount != "" &&
              responseData!.data!.taxAmount != null && responseData!.data!.taxAmount != "null") {
            taxName = responseData!.data!.taxName.toString().split("|");
            taxPrice = responseData!.data!.taxAmount.toString().split("|");
          }
          return responseData;
        } else {
          DialogBox.dialogBoxControl(description: responseData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  updateOrderStatusAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "order_number": widget.orderNumber,
        "status": statusId,
        "status_type": statusType
      };
    
      var response =
      await Dio().post(DefaultApi.apiUrl + PostApi.updateOrderStatusApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        statusData = StatusUpdateModel.fromJson(response.data);
        if (statusData!.status.toString() == "1") {
          setState(() {
            isCome = false;
            orderDetailsAPI();
          });
        } else {
          DialogBox.dialogBoxControl(
              description: statusData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  updateCustomerDetailsAPI(String? editType) async {
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "order_number": widget.orderNumber,
        "customer_name": txtName.text.toString(),
        "email": txtEmail.text.toString(),
        "mobile": txtMobile.text.toString(),
        "edit_type": editType,
        "shipping_address": txtAddress.text.toString(),
        "shipping_landmark": txtLandmark.text.toString(),
        "shipping_postal_code": txtPinCode.text.toString(),
        "shipping_city": txtCity.text.toString(),
        "shipping_state": txtState.text.toString(),
        "shipping_country": txtCountry.text.toString(),
      };
      var response =
      await Dio().post(DefaultApi.apiUrl + PostApi.updateCustomerDetailsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        statusData = StatusUpdateModel.fromJson(response.data);
        if (statusData!.status.toString() == "1") {
          Navigator.pop(context);
          setState(() {
            isCome = false;
            orderDetailsAPI();
          });
        } else {
          DialogBox.dialogBoxControl(
              description: statusData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  updateVendorNotesAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "order_number": widget.orderNumber,
        "note": txtVendorNotes.text.toString(),
      };
      var response =
      await Dio().post(DefaultApi.apiUrl + PostApi.updateVendorNotesApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        statusData = StatusUpdateModel.fromJson(response.data);
        if (statusData!.status.toString() == "1") {
          Navigator.pop(context);
          setState(() {
            isCome = false;
            orderDetailsAPI();
          });
        } else {
          DialogBox.dialogBoxControl(
              description: statusData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  updatePaymentStatusAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "order_number": widget.orderNumber,
        "payment_status": 2
      };
      var response =
      await Dio().post(DefaultApi.apiUrl + PostApi.updatePaymentStatusApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        statusData = StatusUpdateModel.fromJson(response.data);
        if (statusData!.status.toString() == "1") {
          Navigator.pop(context);
          setState(() {
            isCome = false;
            paymentStatus = "2";
            orderDetailsAPI();
          });
        } else {
          DialogBox.dialogBoxControl(
              description: statusData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch (e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: AppScaffold(offlineStatus: (p0) {

      },isCachesEnable: true,
        child: FutureBuilder(
          future: isCome == false ? orderDetailsAPI() : null,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Scaffold(
                appBar: AppBar(
                  surfaceTintColor: FashionHubColors.lightPrimaryColor,
                  backgroundColor: FashionHubColors.lightPrimaryColor,
                  leadingWidth: width / 9,
                  title: Row(
                    children: [
                      Text(
                        'str_order_details'.tr,
                        style: semiBoldFont.copyWith(fontSize: 15.sp),
                      ),
                    ],
                  ),
                  actions: [
                    Row(
                      children: [
                        if (paymentStatus.toString() == "1") ...[
                          InkWell(
                            splashColor: FashionHubColors.transparentColor,
                            highlightColor: FashionHubColors.transparentColor,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                                    surfaceTintColor: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                                    title: Center(
                                      child: Text("str_app_name".tr,
                                          style: boldFont.copyWith(fontSize: 14.sp)),
                                    ),
                                    content: Text(
                                      "str_payment_status_change".tr,
                                      style: regularFont.copyWith(fontSize: 12.sp),
                                    ),
                                    actionsAlignment: MainAxisAlignment.end,
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: FashionHubColors.redColor,
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "str_no".tr,
                                            style: regularFont.copyWith(color: FashionHubColors.whiteColor),
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: FashionHubColors.greenColor,
                                          ),
                                          onPressed: () async {
                                            updatePaymentStatusAPI();
                                          },
                                          child: Text("str_yes".tr,
                                              style:
                                              regularFont.copyWith(color: FashionHubColors.whiteColor)))
                                    ],
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(FashionHubImages.imgPaymentStatus,
                                  height: height / 42,
                                  color: themeData.isDark
                                      ? FashionHubColors.whiteColor
                                      : FashionHubColors.blackColor),
                            ),
                          ),
                        ],
                        if (statusType != "3" && statusType != "4") ...[
                          InkWell(
                            splashColor: FashionHubColors.transparentColor,
                            highlightColor: FashionHubColors.transparentColor,
                            onTap: () {
                              updateOrderStatusBottomSheet();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(FashionHubImages.imgOrderStatus,
                                  height: height / 42,
                                  color: themeData.isDark
                                      ? FashionHubColors.whiteColor
                                      : FashionHubColors.blackColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: height/36, horizontal: width/36),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeData.isDark?FashionHubColors.darkModeColor:FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/66),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${responseData!.data!.orderNumber}",
                                        style: boldFont.copyWith(
                                            fontSize: 13.sp,
                                            color: FashionHubColors.primaryColor),
                                      ),
                                      Text(responseData!.data!.orderDate.toString(),
                                        style: mediumFont.copyWith(
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/96),
                                  Row(
                                    children: [
                                      Text(
                                        "str_payment_method".tr,
                                        style: mediumFont.copyWith(
                                            fontSize: 10.sp),
                                      ),
                                      SizedBox(width: width/96),
                                      Text(
                                        responseData!.paymentName.toString(),
                                        style: mediumFont.copyWith(
                                            fontSize: 10.sp),
                                      ),
                                      const Spacer(),
                                      if (responseData!.data!.paymentStatus.toString() == "2") ...[
                                        Text("str_paid".tr,
                                          style: mediumFont.copyWith(fontSize: 10.sp,color: FashionHubColors.greenColor),
                                        ),
                                      ] else ...[
                                        Text("str_unpaid".tr,
                                          style: mediumFont.copyWith(fontSize: 10.sp,color: FashionHubColors.redColor),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height/96),
                                  Row(
                                    children: [
                                      if (currencyPosition == "1") ...[
                                        Text(
                                          decimalSeparator == 1
                                              ? currencySpace == 1 ?
                                          "$currency ${(double.parse(responseData!.data!.grandTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                          "$currency${(double.parse(responseData!.data!.grandTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                              : currencySpace == 1 ?
                                          "$currency ${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                          "$currency${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                          style: semiBoldFont.copyWith(
                                              fontSize: 14.sp,
                                              color: FashionHubColors.greenColor),
                                        ),
                                      ] else ...[
                                        Text(
                                          decimalSeparator == 1
                                              ? currencySpace == 1 ?
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                              : currencySpace == 1 ?
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                          style: semiBoldFont.copyWith(
                                              fontSize: 14.sp,
                                              color: FashionHubColors.greenColor),
                                        ),
                                      ],
                                      const Spacer(),
                                      if (responseData!.data!.statusType.toString() == "1") ...[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                              FashionHubColors.statusDefaultColor,
                                              borderRadius:
                                              BorderRadius.circular(17)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 26),
                                          height: height / 26,
                                          child: Center(
                                            child: Text(
                                                responseData!.customstatus.toString(),
                                                style: mediumFont.copyWith(
                                                    fontSize: 10.sp,
                                                    color: themeData.isDark
                                                        ? FashionHubColors.whiteColor
                                                        : FashionHubColors.whiteColor)),
                                          ),
                                        ),
                                      ] else if (responseData!.data!.statusType.toString() == "2") ...[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                              FashionHubColors.statusProcessingColor,
                                              borderRadius:
                                              BorderRadius.circular(17)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 26),
                                          height: height / 26,
                                          child: Center(
                                            child: Text(
                                                responseData!.customstatus.toString(),
                                                style: mediumFont.copyWith(
                                                    fontSize: 10.sp,
                                                    color: themeData.isDark
                                                        ? FashionHubColors.whiteColor
                                                        : FashionHubColors.whiteColor)),
                                          ),
                                        ),
                                      ] else if (responseData!.data!.statusType.toString() == "3") ...[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                              FashionHubColors.statusCompleteColor,
                                              borderRadius:
                                              BorderRadius.circular(17)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 26),
                                          height: height / 26,
                                          child: Center(
                                            child: Text(
                                                responseData!.customstatus
                                                    .toString(),
                                                style: mediumFont.copyWith(
                                                    fontSize: 10.sp,
                                                    color: themeData.isDark
                                                        ? FashionHubColors.whiteColor
                                                        : FashionHubColors.whiteColor)),
                                          ),
                                        ),
                                      ] else if (responseData!.data!.statusType.toString() == "4") ...[
                                        Container(
                                          decoration: BoxDecoration(
                                              color:
                                              FashionHubColors.statusCancelColor,
                                              borderRadius:
                                              BorderRadius.circular(17)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 26),
                                          height: height / 26,
                                          child: Center(
                                            child: Text(
                                                responseData!.customstatus
                                                    .toString(),
                                                style: mediumFont.copyWith(
                                                    fontSize: 10.sp,
                                                    color: themeData.isDark
                                                        ? FashionHubColors.whiteColor
                                                        : FashionHubColors.whiteColor)),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height/36),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:themeData.isDark?FashionHubColors.darkModeColor:FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/66),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "str_product_details".tr,
                                    style: boldFont.copyWith(fontSize: 15.sp),
                                  ),
                                  SizedBox(height: height/36),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: responseData!.ordrdetail!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: FashionHubColors.greyColor),
                                        ),
                                        margin: EdgeInsets.only(bottom: height/46),
                                        child: Padding(
                                          padding:EdgeInsets.symmetric(horizontal: width/36,vertical: height/96),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: height/9,
                                                width: width/5,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    image: DecorationImage(
                                                        image: NetworkImage(responseData!
                                                            .ordrdetail![index].productImage
                                                            .toString()),
                                                        fit: BoxFit.cover)),
                                              ),
                                              SizedBox(
                                                width:width/26,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width/1.8,
                                                    child: Text(
                                                      responseData!
                                                          .ordrdetail![index].productName
                                                          .toString(),
                                                      textAlign: TextAlign.start,
                                                      style: semiBoldFont.copyWith(
                                                          fontSize: 11.sp),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:height/120,
                                                  ),
                                                  if ((responseData!
                                                      .ordrdetail![index]
                                                      .variationName != null && responseData!
                                                      .ordrdetail![index]
                                                      .variationName.toString() != "" && responseData!
                                                      .ordrdetail![index]
                                                      .variationName.toString() != "null")
                                                  ) ...[
                                                    InkWell(
                                                      splashColor:
                                                      FashionHubColors.transparentColor,
                                                      highlightColor:
                                                      FashionHubColors.transparentColor,
                                                      onTap: () {
                                                        customizeBottomSheet(
                                                            responseData!
                                                                .ordrdetail![index]
                                                                .productName,
                                                            responseData!
                                                                .ordrdetail![index]
                                                                .variationName,
                                                            responseData!
                                                                .ordrdetail![index]
                                                                .productPrice.toString());
                                                      },
                                                      child: Text(
                                                        "str_customized".tr,
                                                        textAlign: TextAlign.start,
                                                        style: mediumFont.copyWith(
                                                            fontSize: 10.sp,
                                                            color: FashionHubColors.greyColor),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    InkWell(
                                                      splashColor:
                                                      FashionHubColors.transparentColor,
                                                      highlightColor:
                                                      FashionHubColors.transparentColor,
                                                      onTap: () {
                                                      },
                                                      child: Text(
                                                        "-",
                                                        textAlign: TextAlign.start,
                                                        style: mediumFont.copyWith(
                                                            fontSize: 10.sp,
                                                            color: FashionHubColors.greyColor),
                                                      ),
                                                    )
                                                  ],
                                                  SizedBox(
                                                    height:height/120,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                        "str_qty".tr,
                                                        style: regularFont.copyWith(
                                                            fontSize: 10.sp),
                                                      ),
                                                      Text(
                                                        responseData!.ordrdetail![index].qty
                                                            .toString(),
                                                        style: regularFont.copyWith(
                                                            fontSize: 10.sp),
                                                      ),
                                                      SizedBox(width: width/36,),
                                                      SizedBox(
                                                        width: width/2.2,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            if (currencyPosition == "1") ...[
                                                              Text(
                                                                decimalSeparator == 1
                                                                    ? currencySpace == 1 ?
                                                                "$currency ${(double.parse(responseData!.ordrdetail![index].productPrice.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                                                "$currency${(double.parse(responseData!.ordrdetail![index].productPrice.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                                    : currencySpace == 1 ?
                                                                "$currency ${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                                                "$currency${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                                                style: semiBoldFont.copyWith(
                                                                    fontSize: 14.sp,
                                                                    color: FashionHubColors.greenColor),
                                                              ),
                                                            ] else ...[
                                                              Text(
                                                                decimalSeparator == 1
                                                                    ? currencySpace == 1 ?
                                                                "${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                                                "${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                                    : currencySpace == 1 ?
                                                                "${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                                                "${((double.parse(responseData!.ordrdetail![index].productPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                                                style: semiBoldFont.copyWith(
                                                                    fontSize: 14.sp,
                                                                    color: FashionHubColors.greenColor),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height/36),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeData.isDark
                                  ? FashionHubColors.darkModeColor
                                  : FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 36, vertical: height / 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "str_customer_details".tr,
                                        style: boldFont.copyWith(fontSize: 15.sp),
                                      ),
                                      InkWell(
                                        splashColor: FashionHubColors.transparentColor,
                                        highlightColor: FashionHubColors.transparentColor,
                                        onTap: () {
                                          updateCustomerDetailsBottomSheet();
                                        },
                                        child: Image.asset(FashionHubImages.imgEdit,height: height/46,
                                            color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 46),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_name".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      Text(
                                        responseData!.data!.userName.toString(),
                                        style: regularFont.copyWith(fontSize: 11.sp),
                                      ),
                                    ],
                                  ),
                                  if (responseData!.data!.userEmail.toString() != "null") ...[
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_email".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        Text(
                                          responseData!.data!.userEmail.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          splashColor: FashionHubColors.transparentColor,
                                          highlightColor: FashionHubColors.transparentColor,
                                          onTap: () async {
                                            Uri mail = Uri.parse("mailto:${responseData!.data!.userEmail}");
                                            if (await launchUrl(mail)) {
                                              //email app opened
                                            } else {
                                              //email app is not opened
                                            }
                                          },
                                          child: Image.asset(
                                            FashionHubImages.imgEmail,
                                            height: height / 46,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (responseData!.data!.userMobile.toString() != "null") ...[
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_mobile".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        Text(
                                          responseData!.data!.userMobile.toString(),
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          splashColor: FashionHubColors.transparentColor,
                                          highlightColor: FashionHubColors.transparentColor,
                                          onTap: () async {
                                            Uri mobile = Uri.parse("tel:${responseData!.data!.userMobile}");
                                            if (await launchUrl(mobile)) {
                                              //dailer is opened
                                            } else {
                                              //dailer is not opened
                                            }
                                          },
                                          child: Image.asset(
                                            FashionHubImages.imgCall,
                                            height: height / 46,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if(responseData!.biilinginfo!.billingAddress == null || responseData!.biilinginfo!.billingAddress == "")...[]else...[
                            SizedBox(height: height / 36),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeData.isDark
                                    ? FashionHubColors.darkModeColor
                                    : FashionHubColors.whiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 36, vertical: height / 80),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "billing_information".tr,
                                      style: boldFont.copyWith(fontSize: 15.sp),
                                    ),
                                    SizedBox(height: height / 46),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"str_address".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        SizedBox(
                                          width: width/2,
                                          child: Text(responseData!.biilinginfo!.billingAddress.toString(),
                                            style: regularFont.copyWith(fontSize: 11.sp),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          splashColor: FashionHubColors.transparentColor,
                                          highlightColor: FashionHubColors.transparentColor,
                                          onTap: () {
                                            MapsLauncher.launchQuery(responseData!.biilinginfo!.billingAddress.toString());
                                          },
                                          child: Image.asset(
                                            FashionHubImages.imgAddress,
                                            height: height / 46,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_landmark".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (responseData!.biilinginfo!.billingLandmark.toString() != "null") ...[
                                          Text(
                                            responseData!.biilinginfo!.billingLandmark.toString(),
                                            style: regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ] else ...[
                                          Text(
                                            "-",
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_city".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (responseData!.biilinginfo!.billingCity.toString() != "null") ...[
                                          Text(
                                            responseData!.biilinginfo!.billingCity.toString(),
                                            style: regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ] else ...[
                                          Text(
                                            "-",
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_state".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (responseData!.biilinginfo!.billingState.toString() != "null") ...[
                                          Text(
                                            responseData!.biilinginfo!.billingState.toString(),
                                            style: regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ] else ...[
                                          Text(
                                            "-",
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_country".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (responseData!.biilinginfo!.billingCountry.toString() != "null") ...[
                                          Text(
                                            responseData!.biilinginfo!.billingCountry.toString(),
                                            style: regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ] else ...[
                                          Text(
                                            "-",
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"str_postalcode".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (responseData!.biilinginfo!.billingPostalCode.toString() != "null") ...[
                                          Text(responseData!.biilinginfo!.billingPostalCode.toString(),
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ] else ...[
                                          Text(
                                            "-",
                                            style:
                                            regularFont.copyWith(fontSize: 11.sp),
                                          )
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if(responseData!.shippinginfo!.shippingAddress == null || responseData!.shippinginfo!.shippingAddress == "")...[]else...[
                          SizedBox(height: height/36),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeData.isDark
                                  ? FashionHubColors.darkModeColor
                                  : FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 36, vertical: height / 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "shipping_information".tr,
                                        style: boldFont.copyWith(fontSize: 15.sp),
                                      ),
                                      InkWell(
                                        splashColor: FashionHubColors.transparentColor,
                                        highlightColor: FashionHubColors.transparentColor,
                                        onTap: () {
                                          updateAddressDetailsBottomSheet();
                                        },
                                        child: Image.asset(FashionHubImages.imgEdit,height: height/46,
                                            color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 46),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${"str_address".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      SizedBox(
                                        width: width/2,
                                        child: Text(responseData!.shippinginfo!.shippingAddress.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        splashColor: FashionHubColors.transparentColor,
                                        highlightColor: FashionHubColors.transparentColor,
                                        onTap: () {
                                          MapsLauncher.launchQuery(responseData!.shippinginfo!.shippingAddress.toString());
                                        },
                                        child: Image.asset(
                                          FashionHubImages.imgAddress,
                                          height: height / 46,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 96),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_landmark".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (responseData!.shippinginfo!.shippingLandmark.toString() != "null") ...[
                                        Text(
                                          responseData!.shippinginfo!.shippingLandmark.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ] else ...[
                                        Text(
                                          "-",
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height / 96),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_city".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (responseData!.shippinginfo!.shippingCity.toString() != "null") ...[
                                        Text(
                                          responseData!.shippinginfo!.shippingCity.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ] else ...[
                                        Text(
                                          "-",
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height / 96),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_state".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (responseData!.shippinginfo!.shippingState.toString() != "null") ...[
                                        Text(
                                          responseData!.shippinginfo!.shippingState.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ] else ...[
                                        Text(
                                          "-",
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height / 96),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_country".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (responseData!.shippinginfo!.shippingCountry.toString() != "null") ...[
                                        Text(
                                          responseData!.shippinginfo!.shippingCountry.toString(),
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ] else ...[
                                        Text(
                                          "-",
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height / 96),
                                  Row(
                                    children: [
                                      Text(
                                        "${"str_postalcode".tr} : ",
                                        style:
                                        semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (responseData!.shippinginfo!.shippingPostalCode.toString() != "null") ...[
                                        Text(responseData!.shippinginfo!.shippingPostalCode.toString(),
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ] else ...[
                                        Text(
                                          "-",
                                          style:
                                          regularFont.copyWith(fontSize: 11.sp),
                                        )
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ],
                          SizedBox(height:height/36),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:themeData.isDark?FashionHubColors.darkModeColor:FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "str_payment_details".tr,
                                    style: boldFont.copyWith(fontSize: 15.sp),
                                  ),
                                  SizedBox(height: height/46),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "str_subtotal".tr,
                                        style: semiBoldFont.copyWith(fontSize: 11.sp),
                                      ),
                                      if (currencyPosition == "1") ...[
                                        Text(
                                          decimalSeparator == 1
                                              ? currencySpace == 1 ?
                                          "$currency ${(double.parse(responseData!.data!.subTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                          "$currency${(double.parse(responseData!.data!.subTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                              : currencySpace == 1 ?
                                          "$currency ${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                          "$currency${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                          style: semiBoldFont.copyWith(
                                              fontSize: 11.sp),
                                        ),
                                      ] else ...[
                                        Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                            "${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                : currencySpace == 1 ?
                                            "${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                            "${((double.parse(responseData!.data!.subTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp)
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: height/96),
                                  if (responseData!.data!.offerAmount.toString() ==
                                      "null" ||
                                      responseData!.data!.offerAmount.toString() ==
                                          "" ||
                                      responseData!.data!.offerAmount == null) ...[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "str_discount".tr,
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (currencyPosition.toString() ==
                                            "1") ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                            "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                : currencySpace == 1 ?
                                            "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                            "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ] else ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                : currencySpace == 1 ?
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ] else ...[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "str_discount".tr,
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (currencyPosition.toString() ==
                                            "1") ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "$currency ${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                            "$currency${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                : currencySpace == 1 ?
                                            "$currency ${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                            "$currency${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ] else ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace
                                                == 1 ?
                                            "${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                            "${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                : currencySpace == 1 ?
                                            "${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                            "${((double.parse(responseData!.data!.offerAmount.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                  if (taxName.toString() == "" ||
                                      taxName.isEmpty) ...[
                                    Container(),
                                  ] else ...[
                                    SizedBox(height: height / 96),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Text(
                                                taxName[index].toString(),
                                                style:
                                                semiBoldFont.copyWith(fontSize: 11.sp),
                                              ),
                                              const Spacer(),
                                              if (taxPrice.toString() == "" ||
                                                  taxPrice.isEmpty) ...[
                                                if (currencyPosition.toString() ==
                                                    "1") ...[
                                                  Text(decimalSeparator == 1
                                                      ? currencySpace == 1 ?
                                                  "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                                  "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                      : currencySpace == 1 ?
                                                  "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                                  "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                                    style: semiBoldFont.copyWith(
                                                        fontSize: 11.sp),
                                                  ),
                                                ] else ...[
                                                  Text(decimalSeparator == 1
                                                      ? currencySpace == 1 ?
                                                  "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                                  "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                      : currencySpace == 1 ?
                                                  "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                                  "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                                    style: semiBoldFont.copyWith(
                                                        fontSize: 11.sp),
                                                  ),
                                                ],
                                              ] else ...[
                                                if (currencyPosition.toString() ==
                                                    "1") ...[
                                                  Text(decimalSeparator == 1
                                                      ? currencySpace == 1 ?
                                                  "$currency ${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                                  "$currency${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                      : currencySpace == 1 ?
                                                  "$currency ${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                                  "$currency${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                                    style: semiBoldFont.copyWith(
                                                        fontSize: 11.sp),
                                                  ),
                                                ] else ...[
                                                  Text(decimalSeparator == 1
                                                      ? currencySpace == 1 ?
                                                  "${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                                  "${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                      : currencySpace == 1 ?
                                                  "${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                                  "${((double.parse(taxPrice[index].toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                                    style: semiBoldFont.copyWith(
                                                        fontSize: 11.sp),
                                                  ),
                                                ],
                                              ]
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: height / 96,
                                          );
                                        },
                                        itemCount: taxName.length),
                                  ],
                                  if (responseData!.data!.deliveryCharge.toString() ==
                                      "null" ||
                                      responseData!.data!.deliveryCharge.toString() ==
                                          "" ||
                                      responseData!.data!.deliveryCharge == null) ...[
                                    SizedBox(height: height / 96),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "str_delivery_charge".tr,
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (currencyPosition.toString() ==
                                            "1") ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                            "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                : currencySpace == 1 ?
                                            "$currency ${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                            "$currency${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ] else ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                : currencySpace == 1 ?
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                            "${0.00.toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ] else ...[
                                    SizedBox(height: height / 96),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "str_delivery_charge".tr,
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        if (currencyPosition.toString() ==
                                            "1") ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "$currency ${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                            "$currency${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                : currencySpace == 1 ?
                                            "$currency ${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                            "$currency${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ] else ...[
                                          Text(
                                            decimalSeparator == 1
                                                ? currencySpace == 1 ?
                                            "${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                            "${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                : currencySpace == 1 ?
                                            "${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                            "${((double.parse(responseData!.data!.deliveryCharge.toString())).toInt()).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                            style: semiBoldFont.copyWith(
                                                fontSize: 11.sp),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                  SizedBox(height: height/96),
                                  Divider(
                                    height: 1.h,
                                    color: FashionHubColors.greyColor,
                                  ),
                                  SizedBox(height: height/96),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "str_total_amount".tr,
                                        style: boldFont.copyWith(
                                            fontSize: 14.sp, color: FashionHubColors.greenColor),
                                      ),
                                      if (currencyPosition.toString() == "1") ...[
                                        Text(
                                          decimalSeparator == 1
                                              ? currencySpace == 1 ?
                                          "$currency ${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                          "$currency${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                              : currencySpace == 1 ?
                                          "$currency ${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                          "$currency${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                          style: boldFont.copyWith(
                                              fontSize: 14.sp,
                                              color: FashionHubColors.greenColor),
                                        ),
                                      ] else ...[
                                        Text(
                                          decimalSeparator == 1
                                              ? currencySpace == 1 ?
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                              : currencySpace == 1 ?
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                          "${((double.parse(responseData!.data!.grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                          style: boldFont.copyWith(
                                              fontSize: 14.sp,
                                              color: FashionHubColors.greenColor),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if(responseData!.paymentName.toString() != "" &&
                                      responseData!.paymentName.toString() != "null")...[
                                    SizedBox(height: height / 66),
                                    Row(
                                      children: [
                                        Text(
                                          "str_payment_method".tr,
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        SizedBox(width: width/96),
                                        Text(
                                          responseData!.paymentName.toString(),
                                          style: regularFont.copyWith(fontSize: 10.sp),
                                        ),
                                        const Spacer(),
                                        if(responseData!.data!.transactionType.toString() == "6")...[
                                          InkWell(
                                            splashColor: FashionHubColors.transparentColor,
                                            highlightColor: FashionHubColors.transparentColor,
                                            onTap: ()  {
                                              FileDownloader.downloadFile(
                                                url: responseData!.data!.screenShot.toString(),
                                                onProgress: (name, progress) {
                                                  setState(() {
                                                    _progress = progress;
                                                  });
                                                },
                                                onDownloadCompleted: (value) {
                                                  setState(() {
                                                    _progress == null;
                                                  });
                                                  DialogBox.dialogBoxControl(description: "file_downloand_completed".tr);
                                                },
                                                onDownloadError: (errorMessage) {
                                                  DialogBox.dialogBoxControl(description: errorMessage.toString());
                                                },
                                              );
                                            },
                                            child: Image.asset(FashionHubImages.imgDownload,height: height/36,
                                                color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ],
                                  if (responseData!.data!.transactionId.toString() != "" &&
                                      responseData!.data!.transactionId.toString() != "null") ...[
                                    SizedBox(height: height / 96),
                                    Row(
                                      children: [
                                        Text(
                                          "${"payment_id".tr} : ",
                                          style:
                                          semiBoldFont.copyWith(fontSize: 11.sp),
                                        ),
                                        Text(
                                          responseData!.data!.transactionId.toString(),
                                          style:
                                          regularFont.copyWith(fontSize: 10.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (responseData!.data!.notes.toString() != "" &&
                              responseData!.data!.notes.toString() != "null") ...[
                            SizedBox(height: height/36),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:themeData.isDark?FashionHubColors.darkModeColor:FashionHubColors.whiteColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/66),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "order_note".tr,
                                      style: semiBoldFont.copyWith(fontSize: 13.sp),
                                    ),
                                    SizedBox(height: height/46),
                                    Text(
                                      responseData!.data!.notes.toString(),
                                      style: regularFont.copyWith(
                                          fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: height / 36),
                          Container(
                            width: width/1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeData.isDark
                                  ? FashionHubColors.darkModeColor
                                  : FashionHubColors.whiteColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 36, vertical: height / 80),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "str_vendor_notes".tr,
                                        style: boldFont.copyWith(fontSize: 15.sp),
                                      ),
                                      InkWell(
                                        splashColor: FashionHubColors.transparentColor,
                                        highlightColor: FashionHubColors.transparentColor,
                                        onTap: () {
                                          updateVendorNotesBottomSheet();
                                        },
                                        child: Image.asset(FashionHubImages.imgEdit,height: height/46,
                                            color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 60),
                                  Text(responseData!.data!.vendorNote == "" || responseData!.data!.vendorNote == null ? "--" :
                                  responseData!.data!.vendorNote.toString(),
                                    style: regularFont.copyWith(
                                        fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
            );
          },
        ),
      ),
    );
  }

  updateOrderStatusBottomSheet() {
    showModalBottomSheet(
      backgroundColor: FashionHubColors.transparentColor,
      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.whiteColor,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height / 46),
                child: Column(
                  children: [
                    Text(
                      "change_order_status".tr,
                      style: semiBoldFont.copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(height: height / 96),
                    Divider(
                        color: themeData.isDark
                            ? FashionHubColors.darkModeColor
                            : FashionHubColors.greyColor),
                    SizedBox(height: height / 96),
                    ListView.separated(
                      separatorBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: height / 96),
                            Divider(
                                color: themeData.isDark
                                    ? FashionHubColors.darkModeColor
                                    : FashionHubColors.greyColor),
                            SizedBox(height: height / 96),
                          ],
                        );
                      },
                      itemCount: responseData!.statuslist!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          highlightColor: FashionHubColors.transparentColor,
                          splashColor: FashionHubColors.transparentColor,
                          onTap: () {
                            setState(() {
                              statusId = responseData!.statuslist![index].id.toString();
                              statusType = responseData!.statuslist![index].type.toString();
                            });
                            Navigator.pop(context);
                            updateOrderStatusAPI();
                          },
                          child: Center(
                              child: Text(responseData!.statuslist![index].name,
                                style: mediumFont.copyWith(fontSize: 11.sp),
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  updateCustomerDetailsBottomSheet() {
    txtName.value = TextEditingValue(text: responseData!.data!.userName ?? "");
    txtEmail.value = TextEditingValue(text: responseData!.data!.userEmail ?? "");
    txtMobile.value = TextEditingValue(text: responseData!.data!.userMobile ?? "");
    showModalBottomSheet(
      backgroundColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.lightGreyColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height/46),
              child: Column(
                children: [
                  Text(
                    "customer_information".tr,
                    style: semiBoldFont.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: height / 96),
                  Divider(
                      color: themeData.isDark
                          ? FashionHubColors.darkModeColor
                          : FashionHubColors.greyColor),
                  SizedBox(height: height / 96),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtName,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "full_name".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 46),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtEmail,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "email".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 46),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtMobile,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "mobile".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 36),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        if(txtName.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_name_msg".tr);
                        }else if (Validation.validateEmail(txtEmail.text) != null) {
                          DialogBox.dialogBoxControl(
                              description: "valid_email_msg".tr);
                        }else if(txtEmail.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_email_msg".tr);
                        }else if(txtMobile.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_mobile_msg".tr);
                        }else{
                          updateCustomerDetailsAPI("customer_info");
                        }
                      },
                      child: Container(
                        height: height / 15,
                        width: width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: FashionHubColors.primaryColor,
                        ),
                        child: Center(
                          child: Text('submit'.tr,
                              style: boldFont.copyWith(
                                  color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  updateAddressDetailsBottomSheet() {
    txtAddress.value = TextEditingValue(text: responseData!.shippinginfo!.shippingAddress ?? "");
    txtLandmark.value = TextEditingValue(text: responseData!.shippinginfo!.shippingLandmark ?? "");
    txtPinCode.value = TextEditingValue(text: responseData!.shippinginfo!.shippingPostalCode ?? "");
    txtCity.value = TextEditingValue(text: responseData!.shippinginfo!.shippingCity ?? "");
    txtState.value = TextEditingValue(text: responseData!.shippinginfo!.shippingState ?? "");
    txtCountry.value = TextEditingValue(text: responseData!.shippinginfo!.shippingCountry ?? "");
    showModalBottomSheet(
      backgroundColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.lightGreyColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height/46),
              child: Column(
                children: [
                  Text(
                    "billing_information".tr,
                    style: semiBoldFont.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: height / 96),
                  Divider(
                      color: themeData.isDark
                          ? FashionHubColors.darkModeColor
                          : FashionHubColors.greyColor),
                  SizedBox(height: height / 96),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtAddress,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_address".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 46),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtLandmark,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_landmark".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 46),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtPinCode,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_postalcode".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 46),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtCity,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_city".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 36),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtCountry,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_country".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 36),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtState,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_state".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 36),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        if(txtAddress.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_address_msg".tr);
                        }else if(txtLandmark.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_landmark_msg".tr);
                        }else if(txtPinCode.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_postalcode_msg".tr);
                        }else if(txtCity.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_city_msg".tr);
                        }else if(txtCountry.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_country_msg".tr);
                        }else if(txtState.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_state_msg".tr);
                        }else{
                          updateCustomerDetailsAPI("delivery_info");
                        }
                      },
                      child: Container(
                        height: height / 15,
                        width: width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: FashionHubColors.primaryColor,
                        ),
                        child: Center(
                          child: Text('submit'.tr,
                              style: boldFont.copyWith(
                                  color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  updateVendorNotesBottomSheet() {
    txtVendorNotes.value = TextEditingValue(text: responseData!.data!.vendorNote ?? "");
    showModalBottomSheet(
      backgroundColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.lightGreyColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height/46),
              child: Column(
                children: [
                  Text(
                    "str_vendor_notes".tr,
                    style: semiBoldFont.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: height / 96),
                  Divider(
                      color: themeData.isDark
                          ? FashionHubColors.darkModeColor
                          : FashionHubColors.greyColor),
                  SizedBox(height: height / 96),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtVendorNotes,
                        maxLines: 5,
                        style: mediumFont.copyWith(
                            fontSize: 13.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: "str_vendor_notes".tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: mediumFont.copyWith(
                              fontSize: 13.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SizedBox(height: height / 36),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/36),
                    child: InkWell(
                      splashColor: FashionHubColors.transparentColor,
                      highlightColor: FashionHubColors.transparentColor,
                      onTap: () {
                        if(txtVendorNotes.text.isEmpty){
                          DialogBox.dialogBoxControl(
                              description: "enter_notes_msg".tr);
                        }else{
                          updateVendorNotesAPI();
                        }
                      },
                      child: Container(
                        height: height / 15,
                        width: width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: FashionHubColors.primaryColor,
                        ),
                        child: Center(
                          child: Text('submit'.tr,
                              style: boldFont.copyWith(
                                  color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  customizeBottomSheet(String? itemName, String? variantName, String? variantPrice) {
    showModalBottomSheet(
      backgroundColor: FashionHubColors.transparentColor,
      context: context,
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.whiteColor,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height / 66),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width / 1.3,
                            child: Text(
                              itemName!,
                              style: semiBoldFont.copyWith(fontSize: 12.sp),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                size: height / 46,
                              ))
                        ],
                      ),
                    ),
                    Divider(color: FashionHubColors.greyColor),
                    SizedBox(height: height / 96),
                    if (variantName != "" &&
                        variantName != "null" &&
                        variantName != null &&
                        variantPrice != "" &&
                        variantPrice != "null" &&
                        variantPrice != null
                    ) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 26),
                        child: Text(
                          "variant".tr,
                          style: boldFont.copyWith(fontSize: 13.sp),
                        ),
                      ),
                      SizedBox(height: height / 96),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 26),
                        child: Row(
                          children: [
                            Text(
                              "$variantName : ",
                              style: semiBoldFont.copyWith(fontSize: 11.sp),
                            ),
                            if (currencyPosition.toString() == "left") ...[
                              Text(
                                decimalSeparator == 1
                                    ? currencySpace == 1 ?
                                "$currency ${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                "$currency${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                    : currencySpace == 1 ?
                                "$currency ${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                "$currency${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                style: regularFont.copyWith(fontSize: 10.sp),
                              ),
                            ] else ...[
                              Text(
                                decimalSeparator == 1
                                    ? currencySpace == 1 ?
                                "${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                "${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                    : currencySpace == 1 ?
                                "${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                "${((double.parse(variantPrice.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                style: boldFont.copyWith(
                                    fontSize: 14.sp,
                                    color: FashionHubColors.greenColor),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: height / 46),
                    ],
                  ],
                ),
              ),
            ));
      },
    );
  }
}