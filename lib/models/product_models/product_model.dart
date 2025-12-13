class ProductModel {
  String? status;
  String? message;
  List<Product>? data;

  ProductModel({this.status, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(Product.fromJson(v));
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

class Product {
  dynamic id;
  dynamic vendorId;
  dynamic name;
  dynamic description;
  dynamic categoryId;
  dynamic categoryName;
  dynamic price;
  dynamic salePrice;
  dynamic stock;
  dynamic sku;
  dynamic status;
  dynamic featured;
  dynamic image;
  List<String>? images;
  List<Attribute>? attributes;
  dynamic createdAt;
  dynamic updatedAt;

  Product({
    this.id,
    this.vendorId,
    this.name,
    this.description,
    this.categoryId,
    this.categoryName,
    this.price,
    this.salePrice,
    this.stock,
    this.sku,
    this.status,
    this.featured,
    this.image,
    this.images,
    this.attributes,
    this.createdAt,
    this.updatedAt,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    description = json['description'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    price = json['price'];
    salePrice = json['sale_price'];
    stock = json['stock'];
    sku = json['sku'];
    status = json['status'];
    featured = json['featured'];
    image = json['image'];
    if (json['images'] != null) {
      images = <String>[];
      if (json['images'] is List) {
        json['images'].forEach((v) {
          images!.add(v.toString());
        });
      }
    }
    if (json['attributes'] != null) {
      attributes = <Attribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attribute.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['name'] = name;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['price'] = price;
    data['sale_price'] = salePrice;
    data['stock'] = stock;
    data['sku'] = sku;
    data['status'] = status;
    data['featured'] = featured;
    data['image'] = image;
    if (images != null) {
      data['images'] = images;
    }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Attribute {
  dynamic name;
  dynamic value;

  Attribute({this.name, this.value});

  Attribute.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}
