class CouponModel {
  String? status;
  String? message;
  List<CouponData>? data;

  CouponModel({this.status, this.message, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    if (json['data'] != null) {
      data = <CouponData>[];
      json['data'].forEach((v) {
        data!.add(CouponData.fromJson(v));
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

class CouponData {
  String? id;
  String? code;
  String? description;
  String? discountType;
  double? discountValue;
  double? minOrderAmount;
  double? maxDiscountAmount;
  int? usageLimit;
  int? usedCount;
  String? startDate;
  String? endDate;
  String? status;
  String? createdAt;
  String? updatedAt;

  CouponData({
    this.id,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.usageLimit,
    this.usedCount,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CouponData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code']?.toString();
    description = json['description']?.toString();
    discountType = json['discount_type']?.toString();
    discountValue = json['discount_value'] != null ? double.parse(json['discount_value'].toString()) : 0.0;
    minOrderAmount = json['min_order_amount'] != null ? double.parse(json['min_order_amount'].toString()) : 0.0;
    maxDiscountAmount = json['max_discount_amount'] != null ? double.parse(json['max_discount_amount'].toString()) : 0.0;
    usageLimit = json['usage_limit'] != null ? int.parse(json['usage_limit'].toString()) : 0;
    usedCount = json['used_count'] != null ? int.parse(json['used_count'].toString()) : 0;
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['min_order_amount'] = minOrderAmount;
    data['max_discount_amount'] = maxDiscountAmount;
    data['usage_limit'] = usageLimit;
    data['used_count'] = usedCount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
