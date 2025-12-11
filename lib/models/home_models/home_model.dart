class HomeModel {
  dynamic status;
  dynamic message;
  dynamic revenue;
  dynamic totalorders;
  dynamic completedorders;
  dynamic cancelorders;
  List<Data>? data;
  dynamic currency;
  dynamic currencyPosition;
  dynamic adminMobile;
  dynamic adminEmail;
  dynamic adminAddress;
  dynamic decimalSeparator;
  dynamic currencySpace;
  dynamic currencyFormate;

  HomeModel({this.status,
    this.message,
    this.revenue,
    this.totalorders,
    this.completedorders,
    this.cancelorders,
    this.data,
    this.adminEmail,
    this.adminMobile,
    this.currency,
    this.currencyPosition,
    this.adminAddress,
    this.decimalSeparator,
    this.currencySpace,
    this.currencyFormate,
  });

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    revenue = json['revenue'];
    totalorders = json['totalorders'];
    completedorders = json['completedorders'];
    cancelorders = json['cancelorders'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    currency = json['currency'];
    currencyPosition = json['currency_position'];
    adminEmail = json['admin_email'];
    adminMobile = json['admin_mobile'];
    adminAddress = json['admin_address'];
    decimalSeparator = json['decimal_separator'];
    currencySpace = json['currency_space'];
    currencyFormate = json['currency_formate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['revenue'] = revenue;
    data['totalorders'] = totalorders;
    data['completedorders'] = completedorders;
    data['cancelorders'] = cancelorders;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['currency'] = currency;
    data['currency_position'] = currencyPosition;
    data['admin_mobile'] = adminMobile;
    data['admin_email'] = adminEmail;
    data['admin_address'] = adminAddress;
    data['decimal_separator'] = decimalSeparator;
    data['currency_space'] = currencySpace;
    data['currency_formate'] = currencyFormate;
    return data;
  }
}

class Data {
  dynamic id;
  dynamic orderNumber;
  dynamic grandTotal;
  dynamic orderType;
  dynamic status;
  dynamic statusType;
  dynamic orderDate;
  dynamic statusName;
  dynamic paymentStatus;
  dynamic transactionType;
  dynamic paymentName;

  Data(
      {this.id,
        this.orderNumber,
        this.grandTotal,
        this.orderType,
        this.status,
        this.statusType,
        this.orderDate,
        this.statusName,
        this.paymentStatus,
        this.transactionType,
        this.paymentName,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    grandTotal = json['grand_total'];
    status = json['status'];
    statusType = json['status_type'];
    orderDate = json['order_date'];
    statusName = json['status_name'];
    paymentStatus = json['payment_status'];
    transactionType = json['transaction_type'];
    paymentName = json['payment_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['grand_total'] = grandTotal;
    data['status'] = status;
    data['status_type'] = statusType;
    data['order_date'] = orderDate;
    data['status_name'] = statusName;
    data['payment_status'] = paymentStatus;
    data['transaction_type'] = transactionType;
    data['payment_name'] = paymentName;
    return data;
  }
}