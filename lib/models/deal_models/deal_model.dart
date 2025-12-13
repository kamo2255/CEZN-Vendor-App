class DealModel {
  String? status;
  String? message;
  List<DealData>? data;

  DealModel({this.status, this.message, this.data});

  DealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    if (json['data'] != null) {
      data = <DealData>[];
      json['data'].forEach((v) {
        data!.add(DealData.fromJson(v));
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

class DealData {
  String? id;
  String? productId;
  String? productName;
  String? productImage;
  String? dealTitle;
  String? dealDescription;
  double? originalPrice;
  double? dealPrice;
  int? discountPercentage;
  int? availableQuantity;
  int? soldCount;
  String? startDate;
  String? endDate;
  String? status;
  String? featured;
  String? createdAt;
  String? updatedAt;

  DealData({
    this.id,
    this.productId,
    this.productName,
    this.productImage,
    this.dealTitle,
    this.dealDescription,
    this.originalPrice,
    this.dealPrice,
    this.discountPercentage,
    this.availableQuantity,
    this.soldCount,
    this.startDate,
    this.endDate,
    this.status,
    this.featured,
    this.createdAt,
    this.updatedAt,
  });

  DealData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    productImage = json['product_image']?.toString();
    dealTitle = json['deal_title']?.toString();
    dealDescription = json['deal_description']?.toString();
    originalPrice = json['original_price'] != null ? double.parse(json['original_price'].toString()) : 0.0;
    dealPrice = json['deal_price'] != null ? double.parse(json['deal_price'].toString()) : 0.0;
    discountPercentage = json['discount_percentage'] != null ? int.parse(json['discount_percentage'].toString()) : 0;
    availableQuantity = json['available_quantity'] != null ? int.parse(json['available_quantity'].toString()) : 0;
    soldCount = json['sold_count'] != null ? int.parse(json['sold_count'].toString()) : 0;
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    status = json['status']?.toString();
    featured = json['featured']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['deal_title'] = dealTitle;
    data['deal_description'] = dealDescription;
    data['original_price'] = originalPrice;
    data['deal_price'] = dealPrice;
    data['discount_percentage'] = discountPercentage;
    data['available_quantity'] = availableQuantity;
    data['sold_count'] = soldCount;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status'] = status;
    data['featured'] = featured;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
