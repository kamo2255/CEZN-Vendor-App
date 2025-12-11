// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/history_models/orderhistory_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/history_pages/orderdetails_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final themeData = Get.put(ThemeController());
  OrderHistoryModel? responseData;
  String? vendorId;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;

  refreshData() async {
    setState(() {
      orderHistoryAPI();
    });
  }

  Future orderHistoryAPI() async {
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
      };
      var response =
          await Dio().post(DefaultApi.apiUrl + PostApi.orderHistoryApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = OrderHistoryModel.fromJson(response.data);
        if(responseData!.status.toString() == "1") {
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppScaffold(
      offlineStatus: (p0) {

      },isCachesEnable: true,child: Scaffold(
        appBar:  AppBar(
          surfaceTintColor: FashionHubColors.lightPrimaryColor,
          backgroundColor: FashionHubColors.lightPrimaryColor,
          leadingWidth: width/9,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text('str_orders'.tr,
                style: boldFont.copyWith(fontSize: 20.sp),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  FutureBuilder(
                      future: orderHistoryAPI(),
                      builder: (context, sanpshot) {
                        if (!sanpshot.hasData) {
                          return Container();
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/46),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: responseData!.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashColor: FashionHubColors.transparentColor,
                                highlightColor: FashionHubColors.transparentColor,
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsPage(
                                                responseData!.data![index].orderNumber.toString(),
                                                responseData!.data![index].statusType.toString(),
                                                responseData!.data![index].paymentStatus.toString())),
                                  )
                                      .then((val) =>
                                  val ? refreshData() : null);
                                },
                                child: Container(
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
                                              "${responseData!.data![index].orderNumber}",
                                              style: boldFont.copyWith(
                                                  fontSize: 13.sp,
                                                  color: FashionHubColors.primaryColor),
                                            ),
                                            Text(responseData!.data![index].orderDate.toString(),
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
                                              responseData!.data![index].paymentName.toString(),
                                              style: mediumFont.copyWith(
                                                  fontSize: 10.sp),
                                            ),
                                            const Spacer(),
                                            if (responseData!.data![index].paymentStatus.toString() == "2") ...[
                                              Text("paid".tr,
                                                style: mediumFont.copyWith(fontSize: 10.sp,color: FashionHubColors.greenColor),
                                              ),
                                            ] else ...[
                                              Text("unpaid".tr,
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
                                                "$currency ${(double.parse(responseData!.data![index].grandTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}":
                                                "$currency${(double.parse(responseData!.data![index].grandTotal.toString())).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}"
                                                    : currencySpace == 1 ?
                                                "$currency ${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}":
                                                "$currency${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}",
                                                style: semiBoldFont.copyWith(
                                                    fontSize: 14.sp,
                                                    color: FashionHubColors.greenColor),
                                              ),
                                            ] else ...[
                                              Text(
                                                decimalSeparator == 1
                                                    ? currencySpace == 1 ?
                                                "${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')} $currency":
                                                "${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll(',', '.')}$currency"
                                                    : currencySpace == 1 ?
                                                "${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')} $currency":
                                                "${((double.parse(responseData!.data![index].grandTotal.toString()))).toStringAsFixed(currencyFormat!).replaceAll('.', ',')}$currency",
                                                style: semiBoldFont.copyWith(
                                                    fontSize: 14.sp,
                                                    color: FashionHubColors.greenColor),
                                              ),
                                            ],
                                            const Spacer(),
                                            if (responseData!.data![index].statusType.toString() == "1") ...[
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
                                                      responseData!.data![index].statusName.toString(),
                                                      style: mediumFont.copyWith(
                                                          fontSize: 10.sp,
                                                          color: themeData.isDark
                                                              ? FashionHubColors.whiteColor
                                                              : FashionHubColors.whiteColor)),
                                                ),
                                              ),
                                            ] else if (responseData!.data![index].statusType.toString() == "2") ...[
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
                                                      responseData!
                                                          .data![index].statusName
                                                          .toString(),
                                                      style: mediumFont.copyWith(
                                                          fontSize: 10.sp,
                                                          color: themeData.isDark
                                                              ? FashionHubColors.whiteColor
                                                              : FashionHubColors.whiteColor)),
                                                ),
                                              ),
                                            ] else if (responseData!.data![index].statusType.toString() == "3") ...[
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
                                                      responseData!
                                                          .data![index].statusName
                                                          .toString(),
                                                      style: mediumFont.copyWith(
                                                          fontSize: 10.sp,
                                                          color: themeData.isDark
                                                              ? FashionHubColors.whiteColor
                                                              : FashionHubColors.whiteColor)),
                                                ),
                                              ),
                                            ] else if (responseData!.data![index].statusType.toString() == "4") ...[
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
                                                      responseData!
                                                          .data![index].statusName
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
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Container(height: height/46,);
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
