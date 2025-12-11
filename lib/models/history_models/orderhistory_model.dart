class OrderHistoryModel {
 dynamic status;
  dynamic message;
  List<Data>? data;

 OrderHistoryModel({this.status, this.message, this.data});

 OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
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