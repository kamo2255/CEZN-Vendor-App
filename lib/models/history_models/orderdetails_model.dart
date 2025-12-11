class OrderDetailsModel {
  dynamic status;
  dynamic message;
  Data? data;
  List<Ordrdetail>? ordrdetail;
  Biilinginfo? biilinginfo;
  Shippinginfo? shippinginfo;
  dynamic customstatus;
  List<Statuslist>? statuslist;
  dynamic paymentName;

  OrderDetailsModel(
      {this.status,
        this.message,
        this.data,
        this.ordrdetail,
        this.biilinginfo,
        this.shippinginfo,
        this.customstatus,
        this.statuslist,
        this.paymentName});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['ordrdetail'] != null) {
      ordrdetail = <Ordrdetail>[];
      json['ordrdetail'].forEach((v) {
        ordrdetail!.add(Ordrdetail.fromJson(v));
      });
    }
    biilinginfo = json['biilinginfo'] != null
        ? Biilinginfo.fromJson(json['biilinginfo'])
        : null;
    shippinginfo = json['shippinginfo'] != null
        ? Shippinginfo.fromJson(json['shippinginfo'])
        : null;
    customstatus = json['customstatus'];
    if (json['statuslist'] != null) {
      statuslist = <Statuslist>[];
      json['statuslist'].forEach((v) {
        statuslist!.add(Statuslist.fromJson(v));
      });
    }
    paymentName = json['payment_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (ordrdetail != null) {
      data['ordrdetail'] = ordrdetail!.map((v) => v.toJson()).toList();
    }
    if (biilinginfo != null) {
      data['biilinginfo'] = biilinginfo!.toJson();
    }
    if (shippinginfo != null) {
      data['shippinginfo'] = shippinginfo!.toJson();
    }
    data['customstatus'] = customstatus;
    if (statuslist != null) {
      data['statuslist'] = statuslist!.map((v) => v.toJson()).toList();
    }
    data['payment_name'] = paymentName;
    return data;
  }
}

class Data {
  dynamic id;
  dynamic orderNumber;
  dynamic userName;
  dynamic userEmail;
  dynamic userMobile;
  dynamic grandTotal;
  dynamic subTotal;
  dynamic offerCode;
  dynamic offerAmount;
  dynamic taxAmount;
  dynamic deliveryCharge;
  dynamic transactionId;
  dynamic transactionType;
  dynamic status;
  dynamic orderDate;
  dynamic notes;
  dynamic statusType;
  dynamic orderType;
  dynamic paymentStatus;
  dynamic vendorNote;
  dynamic taxName;
  dynamic screenShot;

  Data(
      {this.id,
        this.orderNumber,
        this.userName,
        this.userEmail,
        this.userMobile,
        this.grandTotal,
        this.subTotal,
        this.offerCode,
        this.offerAmount,
        this.taxAmount,
        this.deliveryCharge,
        this.transactionId,
        this.transactionType,
        this.status,
        this.orderDate,
        this.notes,
        this.statusType,
        this.orderType,
        this.paymentStatus,
        this.vendorNote,
        this.taxName,
        this.screenShot,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userMobile = json['user_mobile'];
    grandTotal = json['grand_total'];
    subTotal = json['sub_total'];
    offerCode = json['offer_code'];
    offerAmount = json['offer_amount'];
    taxAmount = json['tax_amount'];
    deliveryCharge = json['delivery_charge'];
    transactionId = json['transaction_id'];
    transactionType = json['transaction_type'];
    status = json['status'];
    orderDate = json['order_date'];
    notes = json['notes'];
    statusType = json['status_type'];
    orderType = json['order_type'];
    paymentStatus = json['payment_status'];
    vendorNote = json['vendor_note'];
    taxName = json['tax_name'];
    screenShot = json['screenshot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_number'] = orderNumber;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_mobile'] = userMobile;
    data['grand_total'] = grandTotal;
    data['sub_total'] = subTotal;
    data['offer_code'] = offerCode;
    data['offer_amount'] = offerAmount;
    data['tax_amount'] = taxAmount;
    data['delivery_charge'] = deliveryCharge;
    data['transaction_id'] = transactionId;
    data['transaction_type'] = transactionType;
    data['status'] = status;
    data['order_date'] = orderDate;
    data['notes'] = notes;
    data['status_type'] = statusType;
    data['order_type'] = orderType;
    data['payment_status'] = paymentStatus;
    data['vendor_note'] = vendorNote;
    data['tax_name'] = taxName;
    data['screenshot'] = screenShot;
    return data;
  }
}

class Ordrdetail {
  dynamic id;
  dynamic orderId;
  dynamic productId;
  dynamic productName;
  dynamic productImage;
  dynamic attribute;
  dynamic variationId;
  dynamic variationName;
  dynamic productPrice;
  dynamic productTax;
  dynamic qty;

  Ordrdetail(
      {this.id,
        this.orderId,
        this.productId,
        this.productName,
        this.productImage,
        this.attribute,
        this.variationId,
        this.variationName,
        this.productPrice,
        this.productTax,
        this.qty});

  Ordrdetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    attribute = json['attribute'];
    variationId = json['variation_id'];
    variationName = json['variation_name'];
    productPrice = json['product_price'];
    productTax = json['product_tax'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    data['attribute'] = attribute;
    data['variation_id'] = variationId;
    data['variation_name'] = variationName;
    data['product_price'] = productPrice;
    data['product_tax'] = productTax;
    data['qty'] = qty;
    return data;
  }
}

class Biilinginfo {
  dynamic billingAddress;
  dynamic billingLandmark;
  dynamic billingPostalCode;
  dynamic billingCity;
  dynamic billingState;
  dynamic billingCountry;

  Biilinginfo(
      {this.billingAddress,
        this.billingLandmark,
        this.billingPostalCode,
        this.billingCity,
        this.billingState,
        this.billingCountry});

  Biilinginfo.fromJson(Map<String, dynamic> json) {
    billingAddress = json['billing_address'];
    billingLandmark = json['billing_landmark'];
    billingPostalCode = json['billing_postal_code'];
    billingCity = json['billing_city'];
    billingState = json['billing_state'];
    billingCountry = json['billing_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billing_address'] = billingAddress;
    data['billing_landmark'] = billingLandmark;
    data['billing_postal_code'] = billingPostalCode;
    data['billing_city'] = billingCity;
    data['billing_state'] = billingState;
    data['billing_country'] = billingCountry;
    return data;
  }
}

class Shippinginfo {
  dynamic shippingAddress;
  dynamic shippingLandmark;
  dynamic shippingPostalCode;
  dynamic shippingCity;
  dynamic shippingState;
  dynamic shippingCountry;

  Shippinginfo(
      {this.shippingAddress,
        this.shippingLandmark,
        this.shippingPostalCode,
        this.shippingCity,
        this.shippingState,
        this.shippingCountry});

  Shippinginfo.fromJson(Map<String, dynamic> json) {
    shippingAddress = json['shipping_address'];
    shippingLandmark = json['shipping_landmark'];
    shippingPostalCode = json['shipping_postal_code'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingCountry = json['shipping_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipping_address'] = shippingAddress;
    data['shipping_landmark'] = shippingLandmark;
    data['shipping_postal_code'] = shippingPostalCode;
    data['shipping_city'] = shippingCity;
    data['shipping_state'] = shippingState;
    data['shipping_country'] = shippingCountry;
    return data;
  }
}

class Statuslist {
  dynamic id;
  dynamic reorderId;
  dynamic vendorId;
  dynamic name;
  dynamic type;
  dynamic isAvailable;
  dynamic isDeleted;
  dynamic orderType;
  dynamic createdAt;
  dynamic updatedAt;

  Statuslist(
      {this.id,
        this.reorderId,
        this.vendorId,
        this.name,
        this.type,
        this.isAvailable,
        this.isDeleted,
        this.orderType,
        this.createdAt,
        this.updatedAt});

  Statuslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reorderId = json['reorder_id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    type = json['type'];
    isAvailable = json['is_available'];
    isDeleted = json['is_deleted'];
    orderType = json['order_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reorder_id'] = reorderId;
    data['vendor_id'] = vendorId;
    data['name'] = name;
    data['type'] = type;
    data['is_available'] = isAvailable;
    data['is_deleted'] = isDeleted;
    data['order_type'] = orderType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}