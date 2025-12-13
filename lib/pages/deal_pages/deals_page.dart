// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/deal_models/deal_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/deal_pages/add_deal_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({Key? key}) : super(key: key);

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  DealModel? dealData;
  String? vendorId;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    currency = pref.getString(currencyPreference);
    currencyPosition = pref.getString(currencyPositionPreference);
    currencyFormat = pref.getInt(currencyFormatPreference);
    decimalSeparator = pref.getInt(decimalSeparatorPreference);
    currencySpace = pref.getInt(currencySpacePreference);
    setState(() {});
  }

  refreshData() async {
    setState(() {
      dealsAPI();
    });
  }

  Future dealsAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        Loader.hideLoading();
        var mockResponse = MockDataService.getMockDeals();
        dealData = DealModel.fromJson(mockResponse);
        return dealData;
      } catch (e) {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "Error loading mock data: $e");
      }
      return null;
    }

    // Real API call
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
      };
      debugPrint("$map");
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.dealsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        dealData = DealModel.fromJson(response.data);
        if (dealData!.status.toString() == "1") {
          return dealData;
        } else {
          DialogBox.dialogBoxControl(description: dealData!.message.toString());
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

  Future<void> deleteDeal(String dealId) async {
    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 300));
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_deal_deleted".tr);
        refreshData();
      } catch (e) {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "Error: $e");
      }
      return;
    }

    // Real API call
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "deal_id": dealId,
      };
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.deleteDealApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        var responseData = response.data;
        if (responseData['status'].toString() == "1") {
          DialogBox.dialogBoxControl(description: "str_deal_deleted".tr);
          refreshData();
        } else {
          DialogBox.dialogBoxControl(description: responseData['message'].toString());
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

  void showDeleteDialog(String dealId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("str_delete_deal".tr, style: boldFont.copyWith(fontSize: 14.sp)),
        content: Text("str_delete_deal_confirm".tr, style: regularFont.copyWith(fontSize: 11.sp)),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: FashionHubColors.greyColor),
            onPressed: () => Get.back(),
            child: Text("str_cancel".tr, style: regularFont.copyWith(color: FashionHubColors.whiteColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: FashionHubColors.redColor),
            onPressed: () {
              Get.back();
              deleteDeal(dealId);
            },
            child: Text("str_delete".tr, style: regularFont.copyWith(color: FashionHubColors.whiteColor)),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    if (currency == null || currencyFormat == null || decimalSeparator == null || currencySpace == null || currencyPosition == null) {
      return amount.toStringAsFixed(2);
    }

    String formattedAmount = decimalSeparator == 1
        ? amount.toStringAsFixed(currencyFormat!).replaceAll(',', '.')
        : amount.toStringAsFixed(currencyFormat!).replaceAll('.', ',');

    if (currencyPosition == "1") {
      return currencySpace == 1 ? "$currency $formattedAmount" : "$currency$formattedAmount";
    } else {
      return currencySpace == 1 ? "$formattedAmount $currency" : "$formattedAmount$currency";
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppScaffold(
      offlineStatus: (p0) {},
      isCachesEnable: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          surfaceTintColor: FashionHubColors.lightPrimaryColor,
          backgroundColor: FashionHubColors.lightPrimaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            "str_top_deals".tr,
            style: boldFont.copyWith(fontSize: 20.sp),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: FutureBuilder(
            future: dealsAPI(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              if (dealData?.data == null || dealData!.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        size: height / 10,
                        color: FashionHubColors.greyColor,
                      ),
                      SizedBox(height: height / 46),
                      Text(
                        "str_no_deals".tr,
                        style: mediumFont.copyWith(fontSize: 14.sp, color: FashionHubColors.greyColor),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
                itemCount: dealData!.data!.length,
                itemBuilder: (context, index) {
                  var deal = dealData!.data![index];
                  bool isActive = deal.status == "1";
                  bool isExpired = false;

                  if (deal.endDate != null) {
                    try {
                      DateTime endDate = DateTime.parse(deal.endDate!);
                      isExpired = endDate.isBefore(DateTime.now());
                    } catch (e) {
                      // Handle parse error
                    }
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDealPage(dealData: deal),
                        ),
                      ).then((value) {
                        if (value == true) refreshData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: deal.productImage != null && deal.productImage!.isNotEmpty
                                ? Image.network(
                                    deal.productImage!,
                                    width: width / 3.5,
                                    height: height / 7,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        FashionHubImages.imgPlaceholder,
                                        width: width / 3.5,
                                        height: height / 7,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    FashionHubImages.imgPlaceholder,
                                    width: width / 3.5,
                                    height: height / 7,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(width / 36),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          deal.dealTitle ?? deal.productName ?? "",
                                          style: boldFont.copyWith(fontSize: 13.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: FashionHubColors.redColor, size: height / 36),
                                        onPressed: () => showDeleteDialog(deal.id!),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 200),
                                  if (deal.dealDescription != null && deal.dealDescription!.isNotEmpty)
                                    Text(
                                      deal.dealDescription!,
                                      style: regularFont.copyWith(fontSize: 10.sp),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  SizedBox(height: height / 100),
                                  Row(
                                    children: [
                                      Text(
                                        formatCurrency(deal.dealPrice ?? 0.0),
                                        style: semiBoldFont.copyWith(fontSize: 14.sp, color: FashionHubColors.greenColor),
                                      ),
                                      SizedBox(width: width / 46),
                                      Text(
                                        formatCurrency(deal.originalPrice ?? 0.0),
                                        style: regularFont.copyWith(
                                          fontSize: 11.sp,
                                          color: FashionHubColors.greyColor,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(width: width / 46),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: FashionHubColors.redColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: width / 66, vertical: height / 400),
                                        child: Text(
                                          "${deal.discountPercentage ?? 0}% OFF",
                                          style: semiBoldFont.copyWith(fontSize: 9.sp, color: FashionHubColors.whiteColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 100),
                                  Row(
                                    children: [
                                      Icon(Icons.inventory_2, size: height / 56, color: FashionHubColors.greyColor),
                                      SizedBox(width: width / 100),
                                      Text(
                                        "${deal.availableQuantity ?? 0} ${"str_available".tr}",
                                        style: regularFont.copyWith(fontSize: 10.sp, color: FashionHubColors.greyColor),
                                      ),
                                      SizedBox(width: width / 36),
                                      Icon(Icons.shopping_cart, size: height / 56, color: FashionHubColors.greyColor),
                                      SizedBox(width: width / 100),
                                      Text(
                                        "${deal.soldCount ?? 0} ${"str_sold".tr}",
                                        style: regularFont.copyWith(fontSize: 10.sp, color: FashionHubColors.greyColor),
                                      ),
                                      const Spacer(),
                                      if (isExpired)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: FashionHubColors.redColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: width / 46, vertical: height / 300),
                                          child: Text(
                                            "str_expired".tr,
                                            style: mediumFont.copyWith(fontSize: 8.sp, color: FashionHubColors.whiteColor),
                                          ),
                                        )
                                      else
                                        Container(
                                          decoration: BoxDecoration(
                                            color: isActive ? FashionHubColors.greenColor : FashionHubColors.greyColor,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: width / 46, vertical: height / 300),
                                          child: Text(
                                            isActive ? "str_active".tr : "str_inactive".tr,
                                            style: mediumFont.copyWith(fontSize: 8.sp, color: FashionHubColors.whiteColor),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: height / 56);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDealPage()),
            ).then((value) {
              if (value == true) refreshData();
            });
          },
          backgroundColor: FashionHubColors.primaryColor,
          child: Icon(Icons.add, color: FashionHubColors.whiteColor),
        ),
      ),
    );
  }
}
