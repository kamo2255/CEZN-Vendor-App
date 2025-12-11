// ignore_for_file: use_build_context_synchronously
//ignore_for_file: must_be_immutable

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/profile_models/contactus_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/validation/validation.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  String? adminEmail;
  String? adminMobile;
  String? adminAddress;

  ContactUsPage(this.adminEmail, this.adminMobile, this.adminAddress,
      {super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMessage = TextEditingController();
  final themeData = Get.put(ThemeController());
  ContactUsModel? responseData;

  contactUsAPI() async {
    try {
      Loader.showLoading();
      var map = {
        "name": txtName.text,
        "mobile": txtMobile.text,
        "email": txtEmail.text,
        "message": txtMessage.text,
      };
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.inquiriesApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = ContactUsModel.fromJson(response.data);
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
          surfaceTintColor: themeData.isDark?FashionHubColors.blackColor:FashionHubColors.whiteColor,
          leadingWidth: width/9,
          title:  Row(
            children: [
              Text(
                'str_contact_us'.tr,
                style:
                semiBoldFont.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
              child: Column(
                children: [
                  Text("str_get_in_touch".tr,style: mediumFont.copyWith(fontSize: 20.sp, ),),
                  SizedBox(height: height/36,),
                  Text("str_get_in_touch_msg".tr,textAlign: TextAlign.center,style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.greyColor),
                    maxLines: 3,
                  ),
                  SizedBox(height: height/36,),
                  InkWell(
                    onTap: () async {
                      Uri mail = Uri.parse("mailto:${widget.adminEmail!}");
                      if (await launchUrl(mail)) {
                        //email app opened
                      } else {
                        //email app is not opened
                      }
                    },
                    child: Container(
                        height: height/13,
                        width: width/1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FashionHubColors.whiteColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/36),
                          child: Row(
                            children: [
                              Image.asset(FashionHubImages.imgEmail,height: height/36,),
                              SizedBox(width: width/36),
                              Text(
                                widget.adminEmail!,
                                style: semiBoldFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: height/36,),
                  InkWell(
                    onTap: () async {
                      Uri phoneno = Uri.parse("tel:${widget.adminMobile!}");
                      if (await launchUrl(phoneno)) {
                        //dailer is opened
                      } else {
                        //dailer is not opened
                      }
                    },
                    child: Container(
                        height: height/13,
                        width: width/1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FashionHubColors.whiteColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/36),
                          child:   Row(
                            children: [
                              Image.asset(FashionHubImages.imgCall,height: height/36,),
                              SizedBox(width: width/36),
                              Text(
                                widget.adminMobile!,
                                style: semiBoldFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: height/36,),
                  InkWell(
                    onTap: () async {
                      MapsLauncher.launchQuery(widget.adminAddress!);
                    },
                    child: Container(
                        height: height / 13,
                        width: width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: FashionHubColors.whiteColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 36),
                          child: Row(
                            children: [
                              Image.asset(
                                FashionHubImages.imgAddress,
                                height: height / 36,
                              ),
                              SizedBox(width: width / 36),
                              SizedBox(
                                width: width/1.3,
                                child: Text(
                                  widget.adminAddress!,
                                  style: semiBoldFont.copyWith(
                                      fontSize: 13.sp, color: FashionHubColors.blackColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: height/26,),
                  Row(
                    children: [
                      Text(
                        "str_your_details".tr,
                        style: semiBoldFont.copyWith(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height/46,
                  ),
                  TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      cursorColor: FashionHubColors.greyColor,
                      style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                      controller: txtName,
                      decoration: InputDecoration(
                        hintText: 'str_name'.tr,
                        fillColor: FashionHubColors.whiteColor,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(FashionHubImages.imgName,height: height/36,),
                        ),
                        hintStyle:
                        regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 1, color: FashionHubColors.lightGreyColor)),
                      )),
                  SizedBox(
                    height: height/36,
                  ),
                  TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      style:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.blackColor),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: FashionHubColors.greyColor,
                      controller: txtEmail,
                      decoration: InputDecoration(
                        hintText: 'str_email'.tr,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(FashionHubImages.imgEmail,height: height/36,),
                        ),
                        fillColor: FashionHubColors.whiteColor,
                        hintStyle:
                        regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 1, color: FashionHubColors.lightGreyColor)),
                      )),
                  SizedBox(
                    height: height/36,
                  ),
                  TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      style:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.blackColor),
                      cursorColor: FashionHubColors.greyColor,
                      keyboardType: TextInputType.phone,
                      controller: txtMobile,
                      decoration: InputDecoration(
                        hintText: 'str_mobile'.tr,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(FashionHubImages.imgCall,height: height/36,),
                        ),
                        fillColor: FashionHubColors.whiteColor,
                        hintStyle:
                        regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 1, color: FashionHubColors.lightGreyColor)),
                      )),
                  SizedBox(
                    height: height/36,
                  ),
                  TextFormField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      style:
                      regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.blackColor),
                      cursorColor: FashionHubColors.greyColor,
                      maxLines: 6,
                      controller: txtMessage,
                      decoration: InputDecoration(
                        hintText: 'str_message'.tr,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              bottom: height / 6, right: 15, left: 15, top: 15),
                          child: Image.asset(FashionHubImages.imgChat,height: height/36,),
                        ),
                        fillColor: FashionHubColors.whiteColor,
                        hintStyle:
                        regularFont.copyWith(fontSize: 12.sp, color: FashionHubColors.greyColor),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 1, color: FashionHubColors.lightGreyColor)),
                      )),
                  SizedBox(height: height/30,),
                  InkWell(
                    onTap: () {
                      if (txtName.text.isEmpty) {
                        DialogBox.dialogBoxControl(
                            description: 'str_enter_all_details'.tr);
                      } else if (txtEmail.text.isEmpty) {
                        DialogBox.dialogBoxControl(
                            description: 'str_enter_all_details'.tr);
                      } else if (Validation.validateEmail(txtEmail.text) != null) {
                        DialogBox.dialogBoxControl(
                            description: "str_valid_email".tr);
                      } else if (txtMobile.text.isEmpty) {
                        DialogBox.dialogBoxControl(
                            description: 'str_enter_all_details'.tr);
                      } else if (txtMessage.text.isEmpty) {
                        DialogBox.dialogBoxControl(
                            description: 'enter_all_details_msg'.tr);
                      } else {
                        contactUsAPI();
                      }
                    },
                    child: Container(
                      height: height/15,
                      width: width/1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: themeData.isDark ? FashionHubColors.primaryColor : FashionHubColors.primaryColor,
                      ),
                      child: Center(
                        child: Text('str_submit'.tr,
                            style: mediumFont.copyWith(
                                color: FashionHubColors.whiteColor, fontSize: 13.sp)),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}