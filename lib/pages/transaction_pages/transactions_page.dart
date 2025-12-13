// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/colors.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/fonts.dart';
import 'package:fashionhub_saas_vendor_flutter_app/common/shared_preferences.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/mock_data_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/network/internetcheck.dart';
import 'package:fashionhub_saas_vendor_flutter_app/models/transaction_models/transaction_model.dart';
import 'package:fashionhub_saas_vendor_flutter_app/theme/theme_controller.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/dialogbox.dart';
import 'package:fashionhub_saas_vendor_flutter_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  dynamic size;
  double height = 0.00;
  double width = 0.00;
  final themeData = Get.find<ThemeController>();
  TransactionModel? transactionData;
  String? vendorId;
  String? currency;
  String? currencyPosition;
  int? currencySpace;
  int? decimalSeparator;
  int? currencyFormat;

  @override
  void initState() {
    super.initState();
    loadCurrencySettings();
  }

  Future<void> loadCurrencySettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);
    currency = pref.getString(currencyPreference);
    currencyPosition = pref.getString(currencyPositionPreference);
    currencyFormat = pref.getInt(currencyFormatPreference);
    decimalSeparator = pref.getInt(decimalSeparatorPreference);
    currencySpace = pref.getInt(currencySpacePreference);
    setState(() {});
  }

  refreshData() async {
    setState(() {
      transactionsAPI();
    });
  }

  Future transactionsAPI() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    vendorId = pref.getString(vendorIdPreference);

    // Use mock data if enabled
    if (MockDataService.USE_MOCK_DATA) {
      try {
        Loader.showLoading();
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        Loader.hideLoading();
        var mockResponse = MockDataService.getMockTransactions();
        transactionData = TransactionModel.fromJson(mockResponse);
        return transactionData;
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
      var response = await Dio().post(DefaultApi.apiUrl + PostApi.transactionsApi, data: map);
      if (response.statusCode == 200) {
        Loader.hideLoading();
        transactionData = TransactionModel.fromJson(response.data);
        if (transactionData!.status.toString() == "1") {
          return transactionData;
        } else {
          DialogBox.dialogBoxControl(description: transactionData!.message.toString());
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

  String formatCurrency(double amount) {
    if (currency == null || currencyFormat == null || decimalSeparator == null || currencySpace == null || currencyPosition == null) {
      return amount.toStringAsFixed(2);
    }

    String formattedAmount = decimalSeparator == 1
        ? amount.toStringAsFixed(currencyFormat!).replaceAll(',', '.')
        : amount.toStringAsFixed(currencyFormat!).replaceAll('.', ',');

    if (currencyPosition == "1") {
      return currencySpace == 1 ? "$currency $formattedAmount" : "$currency$formattedAmount";
    } else {
      return currencySpace == 1 ? "$formattedAmount $currency" : "$formattedAmount$currency";
    }
  }

  Color getTransactionTypeColor(String? type) {
    if (type == null) return FashionHubColors.greenColor;
    switch (type.toLowerCase()) {
      case 'credit':
      case 'payment':
      case 'sale':
        return FashionHubColors.greenColor;
      case 'debit':
      case 'refund':
      case 'withdrawal':
        return FashionHubColors.redColor;
      default:
        return FashionHubColors.blueColor;
    }
  }

  IconData getTransactionIcon(String? type) {
    if (type == null) return Icons.attach_money;
    switch (type.toLowerCase()) {
      case 'credit':
      case 'payment':
      case 'sale':
        return Icons.arrow_downward;
      case 'debit':
      case 'refund':
      case 'withdrawal':
        return Icons.arrow_upward;
      default:
        return Icons.attach_money;
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
          automaticallyImplyLeading: false,
          title: Text(
            "str_transactions".tr,
            style: boldFont.copyWith(fontSize: 20.sp),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshData();
          },
          child: FutureBuilder(
            future: transactionsAPI(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              if (transactionData?.data == null || transactionData!.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: height / 10,
                        color: FashionHubColors.greyColor,
                      ),
                      SizedBox(height: height / 46),
                      Text(
                        "str_no_transactions".tr,
                        style: mediumFont.copyWith(fontSize: 14.sp, color: FashionHubColors.greyColor),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 36),
                itemCount: transactionData!.data!.length,
                itemBuilder: (context, index) {
                  var transaction = transactionData!.data![index];
                  Color transactionColor = getTransactionTypeColor(transaction.transactionType);
                  IconData transactionIcon = getTransactionIcon(transaction.transactionType);

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: themeData.isDark ? FashionHubColors.darkModeColor : FashionHubColors.whiteColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 66),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: transactionColor.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    transactionIcon,
                                    color: transactionColor,
                                    size: height / 36,
                                  ),
                                ),
                              ),
                              SizedBox(width: width / 36),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.orderNumber ?? "str_transaction".tr,
                                      style: boldFont.copyWith(fontSize: 13.sp, color: FashionHubColors.primaryColor),
                                    ),
                                    SizedBox(height: height / 200),
                                    Text(
                                      transaction.transactionId ?? "",
                                      style: mediumFont.copyWith(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatCurrency(transaction.amount ?? 0.0),
                                    style: semiBoldFont.copyWith(fontSize: 14.sp, color: transactionColor),
                                  ),
                                  SizedBox(height: height / 200),
                                  Text(
                                    transaction.transactionDate ?? "",
                                    style: mediumFont.copyWith(fontSize: 9.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (transaction.paymentMethod != null) ...[
                            SizedBox(height: height / 96),
                            Divider(height: 1, color: FashionHubColors.greyColor.withOpacity(0.3)),
                            SizedBox(height: height / 96),
                            Row(
                              children: [
                                Text(
                                  "str_payment_method".tr,
                                  style: mediumFont.copyWith(fontSize: 10.sp),
                                ),
                                SizedBox(width: width / 96),
                                Text(
                                  transaction.paymentMethod ?? "",
                                  style: mediumFont.copyWith(fontSize: 10.sp),
                                ),
                                const Spacer(),
                                if (transaction.transactionType != null) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: transactionColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 200),
                                    child: Text(
                                      transaction.transactionType ?? "",
                                      style: mediumFont.copyWith(fontSize: 9.sp, color: transactionColor),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                          if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                            SizedBox(height: height / 96),
                            Text(
                              transaction.notes ?? "",
                              style: regularFont.copyWith(fontSize: 9.sp, color: FashionHubColors.greyColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
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
      ),
    );
  }
}
