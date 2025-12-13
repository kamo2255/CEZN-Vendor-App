// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/home_models/home_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/history_pages/orderdetails_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/home_pages/dashboard_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/report_pages/reports_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/transaction_pages/transactions_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/coupon_pages/coupons_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/deal_pages/deals_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.put(ThemeController());
  HomeModel? responseData;
  String? vendorId;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;

  @override
  void initState() {
    super.initState();
  }

  refreshData() async {
    setState(() {
      homeAPI();
    });
  }

  Future homeAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
      };
      debugPrint("$map");
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.homeApi,data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = HomeModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          pref.setString(currencyPreference, responseData!.currency.toString());
          pref.setString (currencyPositionPreference, responseData!.currencyPosition.toString());
          pref.setString(adminEmailPreference, responseData!.adminEmail.toString());
          pref.setString (adminMobilePreference, responseData!.adminMobile.toString());
          pref.setString(adminAddressPreference, responseData!.adminAddress.toString());
          if (responseData!.storeName != null) {
            pref.setString('store_name', responseData!.storeName.toString());
          }
          pref.setInt(currencyFormatPreference, responseData!.currencyFormate);
          pref.setInt(decimalSeparatorPreference, responseData!.decimalSeparator);
          pref.setInt(currencySpacePreference, responseData!.currencySpace);
          currency = responseData!.currency.toString();
          currencyPosition = responseData!.currencyPosition.toString();
          currencySpace = responseData!.currencySpace;
          currencyFormat = responseData!.currencyFormate;
          decimalSeparator = responseData!.decimalSeparator;
          return responseData;
        } else {
          DialogBox.dialogBoxControl(description: responseData!.message.toString());
        }
      } else {
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
      }
    } catch(e) {
      Loader.hideLoading();
      DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
    }
  }

  Future<void> saveLanguage(String languageCode, String countryCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    await prefs.setString('countryCode', countryCode);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return AppScaffold(
      offlineStatus: (p0) {

      },isCachesEnable: true,child: Scaffold(
      resizeToAvoidBottomInset: false,
        drawer: _buildDrawer(),
        appBar: AppBar(
          surfaceTintColor: FashionHubColors.lightPrimaryColor,
          backgroundColor: FashionHubColors.lightPrimaryColor,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
          ),
          title: Text(
            "str_dashboard".tr,
            style: boldFont.copyWith(fontSize: 20.sp),
          ),
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setString(changeLanguagePreference, "1");
                    await Get.updateLocale(
                        const Locale('en', 'US'));
                    navigator!.push(MaterialPageRoute(builder: (context) {
                      return const DashboardPage();
                    },
                    ));
                  },
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage:
                        AssetImage(FashionHubImages.imgEnglish),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        "English",
                        style: TextStyle(
                            fontFamily: "Poppins_medium",
                            fontSize: 12.sp),
                      )
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    prefs.setString(changeLanguagePreference, "2");
                    await Get.updateLocale(
                        const Locale('ar', 'ab'));
                    navigator!.push(MaterialPageRoute(
                      builder: (context) {
                        return const DashboardPage();
                      },
                    ));
                  },
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage:
                        AssetImage(FashionHubImages.imgArabic),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        "عربي",
                        style: TextStyle(
                            fontFamily: "Poppins_medium",
                            fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
              offset: const Offset(10, 50),
              padding: EdgeInsets.symmetric(vertical: 1.h),
              surfaceTintColor: themeData.isDark
                  ? FashionHubColors.blackColor
                  : FashionHubColors.whiteColor,
              color: themeData.isDark
                  ? FashionHubColors.blackColor
                  : FashionHubColors.whiteColor,
              elevation: 1,
              icon: Image.asset(
                FashionHubImages.imgLanguage,
                height: 3.h,
                color: themeData.isDark
                    ? FashionHubColors.whiteColor
                    : FashionHubColors.blackColor,
              ),
              iconColor: themeData.isDark
                  ? FashionHubColors.whiteColor
                  : FashionHubColors.blackColor,
              iconSize: 25,
            ),
            IconButton(
              icon: Icon(
                themeData.isDark ? Icons.light_mode : Icons.dark_mode,
                color: themeData.isDark
                    ? FashionHubColors.whiteColor
                    : FashionHubColors.blackColor,
              ),
              onPressed: () {
                themeData.changeThem(!themeData.isDark);
              },
              tooltip: themeData.isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            ),
          ],
        ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: homeAPI(),
          builder: (context,snapshot) {
            if(!snapshot.hasData) {
              return Container();
            }
            return Padding(
              padding:
              EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
              child: Column(
                children: [
                  Container(
                    width: width/1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: FashionHubColors.blueColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/20,vertical: height/46),
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
                                FashionHubImages.imgRevenue,
                                height: height/26,
                                color: FashionHubColors.blueColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/26,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (responseData!.currencyPosition.toString() == "1") ...[
                                Text(
                                  responseData!.decimalSeparator == 1
                                      ? currencySpace == 1 ?
                                  "$currency ${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll(',', '.')}" :
                                  "$currency${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll(',', '.')}"
                                      :  currencySpace == 1 ?
                                  "$currency ${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll('.', ',')}" :
                                  "$currency${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll('.', ',')}",
                                  style: semiBoldFont.copyWith(
                                      fontSize: 16.sp,
                                      color: FashionHubColors.whiteColor),
                                ),
                              ] else ...[
                                Text(
                                  responseData!.decimalSeparator == 1
                                      ? currencySpace == 1 ?
                                  "${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll(',', '.')} $currency":
                                  "${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll(',', '.')}$currency"
                                      : currencySpace == 1 ?
                                  "${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll('.', ',')} $currency":
                                  "${(responseData!.revenue!).toStringAsFixed(currencyFormat).replaceAll('.', ',')}$currency",
                                  style: semiBoldFont.copyWith(
                                      fontSize: 16.sp,
                                      color: FashionHubColors.whiteColor),
                                ),
                              ],
                              SizedBox(height: height/200,),
                              Text(
                                "str_revenue".tr,
                                style: mediumFont.copyWith(fontSize: 13.sp, color: FashionHubColors.whiteColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height/46,),
                  Container(
                    width: width/1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: FashionHubColors.orangeColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/20,vertical: height/46),
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
                                FashionHubImages.imgTotalOrders,
                                height: height/26,
                                color: FashionHubColors.orangeColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/26,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                responseData!.totalorders.toString(),
                                style:
                                semiBoldFont.copyWith(fontSize: 16.sp, color: FashionHubColors.whiteColor),
                              ),
                              SizedBox(height: height/200,),
                              Text(
                                "str_total_orders".tr,
                                style: mediumFont.copyWith(fontSize: 13.sp, color: FashionHubColors.whiteColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height/46,),
                  Container(
                    width: width/1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: FashionHubColors.greenColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/20,vertical: height/46),
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
                                FashionHubImages.imgCompleteOrders,
                                height: height/26,
                                color: FashionHubColors.greenColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/26,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                responseData!.completedorders.toString(),
                                style:
                                semiBoldFont.copyWith(fontSize: 16.sp, color: FashionHubColors.whiteColor),
                              ),
                              SizedBox(height: height/200,),
                              Text(
                                "str_completed_orders".tr,
                                style: mediumFont.copyWith(fontSize: 13.sp, color: FashionHubColors.whiteColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height/46,),
                  Container(
                    width: width/1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: FashionHubColors.redColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/20,vertical: height/46),
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
                                FashionHubImages.imgCancelOrders,
                                height: height/26,
                                color: FashionHubColors.redColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width/26,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                responseData!.cancelorders.toString(),
                                style:
                                semiBoldFont.copyWith(fontSize: 16.sp, color: FashionHubColors.whiteColor),
                              ),
                              SizedBox(height: height/200,),
                              Text(
                                "str_cancelled_orders".tr,
                                style: mediumFont.copyWith(fontSize: 13.sp, color: FashionHubColors.whiteColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height/26,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "str_processing_orders".tr,
                        style: boldFont.copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height/40,
                  ),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
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
                  ),
                ],
              ),
            );
          }
        ),
      ),
          ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: FashionHubColors.lightPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  responseData?.storeName ?? "str_store_name".tr,
                  style: boldFont.copyWith(
                    fontSize: 20.sp,
                    color: FashionHubColors.whiteColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height / 100),
                Text(
                  "str_menu".tr,
                  style: regularFont.copyWith(
                    fontSize: 12.sp,
                    color: FashionHubColors.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.bar_chart_outlined,
            title: "str_reports".tr,
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const ReportsPage());
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long_outlined,
            title: "str_transactions".tr,
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const TransactionsPage());
            },
          ),
          _buildDrawerItem(
            icon: Icons.local_offer_outlined,
            title: "str_coupons".tr,
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const CouponsPage());
            },
          ),
          _buildDrawerItem(
            icon: Icons.local_fire_department_outlined,
            title: "str_top_deals".tr,
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const DealsPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
      ),
      title: Text(
        title,
        style: mediumFont.copyWith(fontSize: 14.sp),
      ),
      onTap: onTap,
    );
  }
}
