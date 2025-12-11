// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/images.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/profile_models/editprofile_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/validation/validation.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as prefix;
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  EditProfileModel? responseData;
  String? vendorId;
  String? vendorName;
  String? vendorEmail;
  String? vendorMobile;
  String imagePath = "";
  String? vendorImage;
  final ImagePicker imagePicker = ImagePicker();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  final themeData = Get.put(ThemeController());

  imagePickerOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Column(
              children: [
                SizedBox(height: height/56,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final XFile? photo = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        imagePath = photo!.path;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child:  Column(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(FashionHubImages.imgCamera,height: height/16,color:themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,),
                            ),
                          ),
                          Text(
                            "str_camera".tr,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'poppins'),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final XFile? photo = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        imagePath = photo!.path;

                        setState(() {});

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                              width: 70,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(FashionHubImages.imgGallery,height: height/16, color : themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor),
                              )
                          ),
                          Text(
                            "str_gallery".tr,
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'poppins'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height/36,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        splashColor: FashionHubColors.transparentColor,
                        highlightColor: FashionHubColors.transparentColor,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("str_cancel".tr,style: regularFont.copyWith(fontSize: 15),)),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorId = prefs.getString(vendorIdPreference);
      vendorName = prefs.getString(vendorNamePreference);
      vendorEmail = prefs.getString(vendorEmailPreference);
      vendorMobile = prefs.getString(vendorMobilePreference);
      vendorImage = prefs.getString(vendorImagePreference);
      txtName.value = TextEditingValue(text: vendorName.toString());
      txtEmail.value = TextEditingValue(text: vendorEmail.toString());
      txtMobile.value = TextEditingValue(text: vendorMobile.toString());
    });
  }

  editProfileAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vendorId = prefs.getString(vendorIdPreference);
    vendorEmail = prefs.getString(vendorEmailPreference);
    vendorMobile = prefs.getString(vendorMobilePreference);
    try {
      Loader.showLoading();
      var formData = FormData();
      if (imagePath.isNotEmpty) {
        formData =  FormData.fromMap({
          "vendor_id":vendorId,
          "name" : txtName.text,
          "email" : txtEmail.text,
          "mobile" : txtMobile.text,
          "profile": await MultipartFile.fromFile(imagePath,
              filename: imagePath.split("/").last)
        });
      } else {
        formData =  FormData.fromMap({
          "vendor_id":vendorId,
          "name" : txtName.text,
          "email" : txtEmail.text,
          "mobile" : txtMobile.text,
        });
      }
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.editProfileApi, data: formData);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        responseData = EditProfileModel.fromJson(response.data);
        if (responseData!.status.toString() == "1") {
          prefs.setString(vendorNamePreference, responseData!.name.toString());
          prefs.setString(vendorEmailPreference, responseData!.email.toString());
          prefs.setString(vendorMobilePreference, responseData!.mobile.toString());
          prefs.setString(vendorImagePreference, responseData!.image.toString());
          Navigator.pop(context,true);
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
                'str_edit_profile'.tr,
                style:
                semiBoldFont.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
      
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: height/6.5,
                      width: height/6.5,
                      child: ClipOval(
                          child: imagePath.isNotEmpty
                              ? Image.file(
                            File(imagePath),
                            fit: BoxFit.fill,
                          )
                              : Image(
                            image:
                            NetworkImage(vendorImage.toString()),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: height/20,
                        width: height/20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeData.isDark ? FashionHubColors.whiteColor : FashionHubColors.blackColor,
                        ),
                        child: InkWell(
                          onTap: () {
                            imagePickerOption();
                          },
                          child: Icon(
                            Icons.mode_edit_outlined,
                            color: themeData.isDark ? FashionHubColors.blackColor : FashionHubColors.whiteColor,
                            size: 22,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height/26,
                ),
                TextFormField(
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    cursorColor: FashionHubColors.greyColor,
                    style: regularFont.copyWith(fontSize: 12.sp,color: FashionHubColors.blackColor),
                    controller: txtName,
                    decoration: InputDecoration(
                      hintText: "str_name".tr,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          FashionHubImages.imgName,
                          height: height / 36,
                        ),
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
                    keyboardType: TextInputType.emailAddress,
                    controller: txtEmail,
                    decoration: InputDecoration(
                      hintText: "str_email".tr,
                      fillColor: FashionHubColors.whiteColor,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          FashionHubImages.imgEmail,
                          height: height / 36,
                        ),
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
                    keyboardType: TextInputType.phone,
                    controller: txtMobile,
                    decoration: InputDecoration(
                      hintText: "str_mobile".tr,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          FashionHubImages.imgCall,
                          height: height / 36,
                        ),
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
                          borderSide:BorderSide.none),
                    )),
                const Spacer(),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (txtName.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (txtEmail.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    } else if (Validation.validateEmail(txtEmail.text) != null) {
                      DialogBox.dialogBoxControl(
                          description: "str_valid_email".tr);
                    }
                    else if (txtMobile.text.isEmpty) {
                      DialogBox.dialogBoxControl(
                          description: "str_enter_all_details".tr);
                    }
                    else if (DemoData.environment == "Test") {
                      DialogBox.dialogBoxControl(
                          description: "str_demo_mode_message".tr);
                    } else {
                      editProfileAPI();
                    }
                  },
                  child:  Container(
                    height: height/15,
                    width: width/1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeData.isDark ? FashionHubColors.primaryColor : FashionHubColors.primaryColor,
                    ),
                    child: Center(
                      child: Text('str_update'.tr,
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
