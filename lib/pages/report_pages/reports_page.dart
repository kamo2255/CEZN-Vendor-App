// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/report_models/report_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  ReportModel? reportData;
  String? vendorId;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;

  @override
  void initState() {
    super.initState();
    loadCurrencySettings();
  }

  Future<void> loadCurrencySettings() async {
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
      reportsAPI();
    });
  }

  Future reportsAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        Loader.hideLoading();
        var mockResponse = MockDataService.getMockReports();
        reportData = ReportModel.fromJson(mockResponse);
        return reportData;
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
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.reportsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        reportData = ReportModel.fromJson(response.data);
        if (reportData!.status.toString() == "1") {
          return reportData;
        } else {
          DialogBox.dialogBoxControl(description: reportData!.message.toString());
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
            "str_reports".tr,
            style: boldFont.copyWith(fontSize: 20.sp),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder(
              future: reportsAPI(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Revenue Section
                      Text(
                        "str_revenue_overview".tr,
                        style: boldFont.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: height / 46),
                      _buildRevenueCard(
                        "str_total_revenue".tr,
                        reportData?.data?.totalRevenue ?? 0.0,
                        FashionHubColors.blueColor,
                        FashionHubImages.imgRevenue,
                      ),
                      SizedBox(height: height / 56),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSmallRevenueCard(
                              "str_today".tr,
                              reportData?.data?.todayRevenue ?? 0.0,
                              FashionHubColors.greenColor,
                            ),
                          ),
                          SizedBox(width: width / 36),
                          Expanded(
                            child: _buildSmallRevenueCard(
                              "str_this_week".tr,
                              reportData?.data?.weekRevenue ?? 0.0,
                              FashionHubColors.orangeColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 56),
                      _buildSmallRevenueCard(
                        "str_this_month".tr,
                        reportData?.data?.monthRevenue ?? 0.0,
                        FashionHubColors.blueColor,
                      ),
                      SizedBox(height: height / 26),

                      // Orders Section
                      Text(
                        "str_orders_overview".tr,
                        style: boldFont.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: height / 46),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "str_total_orders".tr,
                              reportData?.data?.totalOrders.toString() ?? "0",
                              FashionHubColors.blueColor,
                              Icons.shopping_cart,
                            ),
                          ),
                          SizedBox(width: width / 36),
                          Expanded(
                            child: _buildStatCard(
                              "str_today_orders".tr,
                              reportData?.data?.todayOrders.toString() ?? "0",
                              FashionHubColors.greenColor,
                              Icons.today,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 56),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "str_completed".tr,
                              reportData?.data?.completedOrders.toString() ?? "0",
                              FashionHubColors.greenColor,
                              Icons.check_circle,
                            ),
                          ),
                          SizedBox(width: width / 36),
                          Expanded(
                            child: _buildStatCard(
                              "str_pending".tr,
                              reportData?.data?.pendingOrders.toString() ?? "0",
                              FashionHubColors.orangeColor,
                              Icons.pending,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 56),
                      _buildStatCard(
                        "str_cancelled".tr,
                        reportData?.data?.cancelledOrders.toString() ?? "0",
                        FashionHubColors.redColor,
                        Icons.cancel,
                      ),
                      SizedBox(height: height / 26),

                      // Products Section
                      Text(
                        "str_products_overview".tr,
                        style: boldFont.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: height / 46),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "str_total_products".tr,
                              reportData?.data?.totalProducts.toString() ?? "0",
                              FashionHubColors.blueColor,
                              Icons.inventory_2,
                            ),
                          ),
                          SizedBox(width: width / 36),
                          Expanded(
                            child: _buildStatCard(
                              "str_active_products".tr,
                              reportData?.data?.activeProducts.toString() ?? "0",
                              FashionHubColors.greenColor,
                              Icons.check_circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 56),
                      _buildStatCard(
                        "str_out_of_stock".tr,
                        reportData?.data?.outOfStockProducts.toString() ?? "0",
                        FashionHubColors.redColor,
                        Icons.warning,
                      ),
                      SizedBox(height: height / 26),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueCard(String title, double amount, Color color, String icon) {
    return Container(
      width: width / 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 20, vertical: height / 46),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: FashionHubColors.whiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  icon,
                  height: height / 26,
                  color: color,
                ),
              ),
            ),
            SizedBox(width: width / 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatCurrency(amount),
                  style: semiBoldFont.copyWith(fontSize: 16.sp, color: FashionHubColors.whiteColor),
                ),
                SizedBox(height: height / 200),
                Text(
                  title,
                  style: mediumFont.copyWith(fontSize: 13.sp, color: FashionHubColors.whiteColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallRevenueCard(String title, double amount, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatCurrency(amount),
              style: semiBoldFont.copyWith(fontSize: 14.sp, color: FashionHubColors.whiteColor),
            ),
            SizedBox(height: height / 200),
            Text(
              title,
              style: mediumFont.copyWith(fontSize: 11.sp, color: FashionHubColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
        border: Border.all(color: color, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 26, vertical: height / 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: height / 26,
            ),
            SizedBox(height: height / 100),
            Text(
              value,
              style: semiBoldFont.copyWith(fontSize: 18.sp, color: color),
            ),
            SizedBox(height: height / 200),
            Text(
              title,
              style: mediumFont.copyWith(fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}
