// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/profile_models/changepassword_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ChangePasswordModel? responseData;
  String? vendorId;
  TextEditingController txtOldPassword = TextEditingController();
  TextEditingController txtNewPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  final themeData = Get.put(ThemeController());
  bool oldHidden=true;
  bool newHidden=true;
  bool confirmHidden=true;

  changePasswordAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vendorId = prefs.getString(vendorIdPreference);
    try {
      Loader.showLoading();
      var map = {
        "vendor_id": vendorId,
        "current_password": txtOldPassword.text,
        "new_password": txtNewPassword.text,
        "confirm_password": txtConfirmPassword.text,
      };
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.changePasswordApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = ChangePasswordModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          Navigator.pop(context);
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

  void toggleOldPasswordStatus() {
    setState(() {
      oldHidden = !oldHidden;
    });
  }

  void toggleNewPasswordStatus() {
    setState(() {
      newHidden = !newHidden;
    });
  }

  void toggleConfirmPasswordStatus() {
    setState(() {
      confirmHidden = !confirmHidden;
    });
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
        appBar:  AppBar(
          leadingWidth: width/9,
          surfaceTintColor: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.whiteColor,
          title:  Row(
            children: [
              Text(
                'str_change_password'.tr,
                style:
                semiBoldFont.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
      
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    cursorColor: FashionHubColors.greyColor,
                    style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                    controller: txtOldPassword,
                    obscureText: oldHidden,
                    decoration: InputDecoration(
                      hintText: 'str_old_password'.tr,
                      fillColor: FashionHubColors.whiteColor,
                      hintStyle:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          oldHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: toggleOldPasswordStatus,
                        color: FashionHubColors.greyColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none),
                    )),
                SizedBox(
                  height: 2.h,
                ),
                TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    cursorColor: FashionHubColors.greyColor,
                    style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                    controller: txtNewPassword,
                    obscureText: newHidden,
                    decoration: InputDecoration(
                      hintText: 'str_new_password'.tr,
                      fillColor: FashionHubColors.whiteColor,
                      hintStyle:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          newHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: toggleNewPasswordStatus,
                        color: FashionHubColors.greyColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none),
                    )),
                SizedBox(
                  height: 2.h,
                ),
                TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    style:
                    regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.blackColor),
                    cursorColor: FashionHubColors.greyColor,
                    obscureText: confirmHidden,
                    controller: txtConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'str_confirm_password'.tr,
                      fillColor: FashionHubColors.whiteColor,
                      hintStyle:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          confirmHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: toggleConfirmPasswordStatus,
                        color: FashionHubColors.greyColor,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:BorderSide.none),
                    )),
                const Spacer(),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (txtOldPassword.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (txtNewPassword.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (txtConfirmPassword.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (txtNewPassword.text != txtConfirmPassword.text) {
                      DialogBox.dialogBoxControl(
                          description: "str_password_msg".tr);
                    } else if (DemoData.environment == "Test") {
                      DialogBox.dialogBoxControl(
                          description: "str_demo_mode_message".tr);
                    } else {
                      changePasswordAPI();
                    }
                  },
                  child:   Container(
                    height: height/15,
                    width: width/1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:themeData.isDark ? FashionHubColors.primaryColor : FashionHubColors.primaryColor,
                    ),
                    child: Center(
                      child: Text('str_reset'.tr,
                          style: mediumFont.copyWith(
                              color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
