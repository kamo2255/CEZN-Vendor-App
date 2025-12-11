import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/theme_controller.dart';

class Loader {
  static void showLoading() {
    final themeData = Get.put(ThemeController());
    Get.dialog(
      barrierColor: themeData.isDark
          ? FashionHubColors.blackColor
          : FashionHubColors.whiteColor,
      barrierDismissible: false,
      Center(
          child: CircularProgressIndicator(
            color: themeData.isDark
                ? FashionHubColors.whiteColor
                : FashionHubColors.primaryColor,
          )),
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}