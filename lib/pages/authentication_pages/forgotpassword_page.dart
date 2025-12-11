import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/authentication_models/forgotpassword_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/pages/authentication_pages/login_page.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/validation/validation.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final themeData = Get.put(ThemeController());
  bool isHidden = true;
  ForgotPasswordModel? responseData;
  TextEditingController txtEmail = TextEditingController();

  Future forgotPasswordAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "email": txtEmail.text,
      };
      var response = await Dio()
          .post(DefaultApi.apiUrl + PostApi.forgotPasswordApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = ForgotPasswordModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          Get.off(() => const LoginPage());
        } else {
          DialogBox.dialogBoxControl(
              description: responseData!.message.toString());
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
      offlineStatus: (p0) {},
      isCachesEnable: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          surfaceTintColor: FashionHubColors.lightPrimaryColor,
          backgroundColor: FashionHubColors.lightPrimaryColor,
          title: Row(
            children: [
              Text(
                "str_forgot_password".tr,
                style: boldFont.copyWith(fontSize: 20.sp),
              ),
            ],
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 36, vertical: height / 26),
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
                        child: Image.asset(
                          FashionHubImages.imgEmail,
                          height: height / 36,
                        ),
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
                SizedBox(height: height / 30),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (txtEmail.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (Validation.validateEmail(txtEmail.text) !=
                        null) {
                      DialogBox.dialogBoxControl(
                          description: "str_valid_email".tr);
                    } else if (DemoData.environment == "Test") {
                      DialogBox.dialogBoxControl(
                          description: "str_demo_mode".tr);
                    } else {
                      forgotPasswordAPI();
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
                      child: Text('str_submit'.tr,
                          style: boldFont.copyWith(
                              color: FashionHubColors.whiteColor,
                              fontSize: 13.sp)),
                    ),
                  ),
                ),
                SizedBox(height: height / 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("str_remember_password".tr,
                        style: regularFont.copyWith(
                            fontSize: 13.sp,
                            color: FashionHubColors.greyColor)),
                    SizedBox(
                      width: width / 96,
                    ),
                    InkWell(
                        highlightColor: FashionHubColors.transparentColor,
                        splashColor: FashionHubColors.transparentColor,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const LoginPage();
                            },
                          ));
                        },
                        child: Text("str_login".tr,
                            style: boldFont.copyWith(
                              fontSize: 13.sp,
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
