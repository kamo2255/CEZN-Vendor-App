import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String? buttonText;
  final String? text;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;
  final bool loading;
  final bool? isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    this.buttonText,
    this.text,
    this.onTap,
    this.onPressed,
    this.loading = false,
    this.isLoading,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoadingState = isLoading ?? loading;
    final VoidCallback? callback = onPressed ?? onTap;
    final String displayText = text ?? buttonText ?? '';

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isLoadingState ? null : callback,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? FashionHubColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: isLoadingState
            ? SizedBox(
                height: 2.5.h,
                width: 2.5.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                displayText.isNotEmpty ? displayText : '',
                style: TextStyle(
                  fontFamily: "OpenSansBold",
                  fontSize: 11.sp,
                  color: textColor ?? FashionHubColors.whiteColor,
                ),
              ),
      ),
    );
  }
}
