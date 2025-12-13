class TransactionModel {
  String? status;
  String? message;
  List<TransactionData>? data;

  TransactionModel({this.status, this.message, this.data});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
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

class TransactionData {
  String? id;
  String? transactionId;
  String? orderId;
  String? orderNumber;
  String? transactionType;
  double? amount;
  String? paymentMethod;
  String? paymentStatus;
  String? transactionDate;
  String? notes;
  String? createdAt;

  TransactionData({
    this.id,
    this.transactionId,
    this.orderId,
    this.orderNumber,
    this.transactionType,
    this.amount,
    this.paymentMethod,
    this.paymentStatus,
    this.transactionDate,
    this.notes,
    this.createdAt,
  });

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    transactionId = json['transaction_id']?.toString();
    orderId = json['order_id']?.toString();
    orderNumber = json['order_number']?.toString();
    transactionType = json['transaction_type']?.toString();
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0;
    paymentMethod = json['payment_method']?.toString();
    paymentStatus = json['payment_status']?.toString();
    transactionDate = json['transaction_date']?.toString();
    notes = json['notes']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['order_id'] = orderId;
    data['order_number'] = orderNumber;
    data['transaction_type'] = transactionType;
    data['amount'] = amount;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['transaction_date'] = transactionDate;
    data['notes'] = notes;
    data['created_at'] = createdAt;
    return data;
  }
}
