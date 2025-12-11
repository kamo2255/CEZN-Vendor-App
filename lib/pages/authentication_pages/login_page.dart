// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/authentication_models/login_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/forgotpassword_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/home_pages/dashboard_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/validation/validation.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final themeData = Get.put(ThemeController());
  bool isHidden = true;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken;
  LoginModel? responseData;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  void _togglePasswordStatus() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseMessaging.getToken().then((token) {
      fcmToken = token;
    });
    if (DemoData.environment == "Test") {
      txtEmail.value = TextEditingValue(text: DemoData.demoEmail);
      txtPassword.value = TextEditingValue(text: DemoData.demoPassword);
    }
  }

  Future loginAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "email": txtEmail.text,
        "password": txtPassword.text,
        "login_type": "normal",
        "token": fcmToken
      };
      var response =
          await Dio().post(DefaultApi.apiUrl + PostApi.loginApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = LoginModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString(vendorIdPreference, responseData!.data!.id.toString());
          pref.setString(vendorNamePreference, responseData!.data!.name.toString());
          pref.setString(vendorEmailPreference, responseData!.data!.email.toString());
          pref.setString(vendorImagePreference, responseData!.data!.image.toString());
          pref.setString(vendorMobilePreference, responseData!.data!.mobile.toString());
          Get.to(() => const DashboardPage());
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

  Future<bool> _onBackPressed() async {
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
                        style:
                            regularFont.copyWith(color: FashionHubColors.whiteColor)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: AppScaffold(offlineStatus: (p0) {

        },isCachesEnable: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              surfaceTintColor: FashionHubColors.lightPrimaryColor,
              backgroundColor: FashionHubColors.lightPrimaryColor,
              automaticallyImplyLeading: false,
              title:  Row(
                children: [
                  Text(
                    "str_login".tr,
                    style: boldFont.copyWith(fontSize: 20.sp),
                  ),
                ],
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
                        navigator!.push(MaterialPageRoute(
                          builder: (context) {
                            return const LoginPage();
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
                            return const LoginPage();
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
              ],
            ),
            body: Form(
              key: formKey,
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: width/36,vertical: height/26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        style: regularFont.copyWith(
                            fontSize: 12.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: 'str_email'.tr,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(FashionHubImages.imgEmail,height: height/36,),
                          ),
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: regularFont.copyWith(
                              fontSize: 12.sp, color: FashionHubColors.greyColor),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                    SizedBox(height: height/36),
                    TextField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        cursorColor: FashionHubColors.greyColor,
                        controller: txtPassword,
                        obscureText: isHidden,
                        style: regularFont.copyWith(
                            fontSize: 12.sp, color: FashionHubColors.blackColor),
                        decoration: InputDecoration(
                          hintText: 'str_password'.tr,
                          fillColor: FashionHubColors.whiteColor,
                          hintStyle: regularFont.copyWith(
                              fontSize: 12.sp, color: FashionHubColors.greyColor),
                          suffixIcon: IconButton(
                            icon: Image.asset(
                              isHidden
                                  ? FashionHubImages.imgEyeSlash
                                  : FashionHubImages.imgEye,
                              height: height / 36,
                            ),
                            onPressed: _togglePasswordStatus,
                            color: FashionHubColors.greyColor,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(FashionHubImages.imgPassword,height: height/36,),
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        )),
                    SizedBox(height: height/46),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          highlightColor: FashionHubColors.transparentColor,
                          splashColor: FashionHubColors.transparentColor,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const ForgotPasswordPage();
                              },
                            ));
                          },
                          child: Text(
                            "str_forgot_password_ask".tr,
                            style: boldFont.copyWith(fontSize: 13.sp),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height/30),
                    InkWell(
                      highlightColor: FashionHubColors.transparentColor,
                      splashColor: FashionHubColors.transparentColor,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (txtEmail.text.isEmpty) {
                          DialogBox.dialogBoxControl(
                              description: "str_enter_all_details".tr);
                        } else if (Validation.validateEmail(txtEmail.text) !=
                            null) {
                          DialogBox.dialogBoxControl(
                              description: "str_valid_email".tr);
                        }
                        else if (txtPassword.text.isEmpty) {
                          DialogBox.dialogBoxControl(
                              description: "str_enter_all_details".tr);
                        } else {
                          loginAPI();
                        }
                      },
                      child: Container(
                        height: height/15,
                        width: width/1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color:
                          FashionHubColors.primaryColor,
                        ),
                        child: Center(
                          child: Text('str_login'.tr,
                              style: boldFont.copyWith(
                                  color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
