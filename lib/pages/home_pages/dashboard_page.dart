// ignore_for_file: deprecated_member_use

import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/home_pages/home_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/history_pages/orderhistory_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/profile_pages/profile_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  int selectIndex = 0;
  final themeData = Get.find<ThemeController>();
  final PageController pageController = PageController();

  Future<bool> onBackPressed() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("str_app_name".tr,
              style: boldFont.copyWith(fontSize: 14.sp)),
          content: Text(
            "str_exit_app".tr,
            style: regularFont.copyWith(fontSize: 11.sp),
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
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("str_yes".tr,
                    style: regularFont.copyWith(color: FashionHubColors.whiteColor)))
          ],
        ));
  }

  void onTappedBar(int value) {
    setState(() {
      selectIndex = value;
    });
    pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: GetBuilder<ThemeController>(builder: (controller) {
        return Scaffold(
          body:
              PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [HomePage(), OrderHistoryPage(), ProfilePage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.lightGreyColor,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  FashionHubImages.imgHome,
                  color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
                  height: height/36,
                ),
                label: "str_dashboard".tr,
                activeIcon: Image.asset(
                  FashionHubImages.imgHome,
                  color: FashionHubColors.primaryColor,
                  height: height/36,
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  FashionHubImages.imgOrders,
                  color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
                  height: height/36,
                ),
                label: "str_orders".tr,
                activeIcon: Image.asset(
                  FashionHubImages.imgOrders,
                  color: FashionHubColors.primaryColor,
                  height: height/36,
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  FashionHubImages.imgName,
                  color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
                  height: height/36,
                ),
                label: "str_profile".tr,
                activeIcon: Image.asset(
                  FashionHubImages.imgName,
                  color: FashionHubColors.primaryColor,
                  height: height/36,
                ),
              ),
            ],
            onTap: onTappedBar,
            currentIndex: selectIndex,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 1,
            unselectedFontSize: 1,
            selectedLabelStyle: mediumFont.copyWith(fontSize: 8.sp),
            unselectedLabelStyle: regularFont.copyWith(fontSize: 8.sp),
            selectedItemColor: FashionHubColors.primaryColor,
            unselectedItemColor: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
          ),
        );
      }),
    );
  }
}
