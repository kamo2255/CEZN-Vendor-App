// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/coupon_models/coupon_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/coupon_pages/add_coupon_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({Key? key}) : super(key: key);

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  CouponModel? couponData;
  String? vendorId;

  @override
  void initState() {
    super.initState();
    loadVendorId();
  }

  Future<void> loadVendorId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    setState(() {});
  }

  refreshData() async {
    setState(() {
      couponsAPI();
    });
  }

  Future couponsAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        Loader.hideLoading();
        var mockResponse = MockDataService.getMockCoupons();
        couponData = CouponModel.fromJson(mockResponse);
        return couponData;
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
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.couponsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        couponData = CouponModel.fromJson(response.data);
        if (couponData!.status.toString() == "1") {
          return couponData;
        } else {
          DialogBox.dialogBoxControl(description: couponData!.message.toString());
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

  Future<void> deleteCoupon(String couponId) async {
    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 300));
        Loader.hideLoading();
        DialogBox.dialogBoxControl(description: "str_coupon_deleted".tr);
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
        "coupon_id": couponId,
      };
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.deleteCouponApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        var responseData = response.data;
        if (responseData['status'].toString() == "1") {
          DialogBox.dialogBoxControl(description: "str_coupon_deleted".tr);
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

  void showDeleteDialog(String couponId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("str_delete_coupon".tr, style: boldFont.copyWith(fontSize: 14.sp)),
        content: Text("str_delete_coupon_confirm".tr, style: regularFont.copyWith(fontSize: 11.sp)),
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
              deleteCoupon(couponId);
            },
            child: Text("str_delete".tr, style: regularFont.copyWith(color: FashionHubColors.whiteColor)),
          ),
        ],
      ),
    );
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
            "str_coupons".tr,
            style: boldFont.copyWith(fontSize: 20.sp),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: FutureBuilder(
            future: couponsAPI(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              if (couponData?.data == null || couponData!.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: height / 10,
                        color: FashionHubColors.greyColor,
                      ),
                      SizedBox(height: height / 46),
                      Text(
                        "str_no_coupons".tr,
                        style: mediumFont.copyWith(fontSize: 14.sp, color: FashionHubColors.greyColor),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
                itemCount: couponData!.data!.length,
                itemBuilder: (context, index) {
                  var coupon = couponData!.data![index];
                  bool isActive = coupon.status == "1";
                  bool isExpired = false;

                  if (coupon.endDate != null) {
                    try {
                      DateTime endDate = DateTime.parse(coupon.endDate!);
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
                          builder: (context) => AddCouponPage(couponData: coupon),
                        ),
                      ).then((value) {
                        if (value == true) refreshData();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                        border: Border.all(
                          color: isExpired ? FashionHubColors.redColor :
                                 isActive ? FashionHubColors.greenColor : FashionHubColors.greyColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width / 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: FashionHubColors.primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width / 36,
                                              vertical: height / 200,
                                            ),
                                            child: Text(
                                              coupon.code ?? "",
                                              style: boldFont.copyWith(
                                                fontSize: 14.sp,
                                                color: FashionHubColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          if (isExpired)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: FashionHubColors.redColor,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width / 36,
                                                vertical: height / 200,
                                              ),
                                              child: Text(
                                                "str_expired".tr,
                                                style: mediumFont.copyWith(
                                                  fontSize: 9.sp,
                                                  color: FashionHubColors.whiteColor,
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              decoration: BoxDecoration(
                                                color: isActive ? FashionHubColors.greenColor : FashionHubColors.greyColor,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width / 36,
                                                vertical: height / 200,
                                              ),
                                              child: Text(
                                                isActive ? "str_active".tr : "str_inactive".tr,
                                                style: mediumFont.copyWith(
                                                  fontSize: 9.sp,
                                                  color: FashionHubColors.whiteColor,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: height / 100),
                                      if (coupon.description != null && coupon.description!.isNotEmpty)
                                        Text(
                                          coupon.description!,
                                          style: regularFont.copyWith(fontSize: 11.sp),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 66),
                            Divider(height: 1, color: FashionHubColors.greyColor.withOpacity(0.3)),
                            SizedBox(height: height / 66),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "str_discount".tr,
                                        style: mediumFont.copyWith(fontSize: 9.sp, color: FashionHubColors.greyColor),
                                      ),
                                      Text(
                                        coupon.discountType == "percentage"
                                            ? "${coupon.discountValue?.toStringAsFixed(0)}%"
                                            : "${coupon.discountValue?.toStringAsFixed(2)}",
                                        style: semiBoldFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greenColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "str_usage".tr,
                                        style: mediumFont.copyWith(fontSize: 9.sp, color: FashionHubColors.greyColor),
                                      ),
                                      Text(
                                        "${coupon.usedCount ?? 0} / ${coupon.usageLimit ?? 0}",
                                        style: semiBoldFont.copyWith(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "str_valid_until".tr,
                                        style: mediumFont.copyWith(fontSize: 9.sp, color: FashionHubColors.greyColor),
                                      ),
                                      Text(
                                        coupon.endDate ?? "-",
                                        style: semiBoldFont.copyWith(fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: FashionHubColors.redColor),
                                  onPressed: () => showDeleteDialog(coupon.id!),
                                ),
                              ],
                            ),
                          ],
                        ),
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
              MaterialPageRoute(builder: (context) => const AddCouponPage()),
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
