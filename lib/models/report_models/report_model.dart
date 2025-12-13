class ReportModel {
  String? status;
  String? message;
  ReportData? data;

  ReportModel({this.status, this.message, this.data});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    message = json['message'];
    data = json['data'] != null ? ReportData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReportData {
  double? totalRevenue;
  double? todayRevenue;
  double? weekRevenue;
  double? monthRevenue;
  int? totalOrders;
  int? todayOrders;
  int? weekOrders;
  int? monthOrders;
  int? completedOrders;
  int? pendingOrders;
  int? cancelledOrders;
  int? totalProducts;
  int? activeProducts;
  int? outOfStockProducts;

  ReportData({
    this.totalRevenue,
    this.todayRevenue,
    this.weekRevenue,
    this.monthRevenue,
    this.totalOrders,
    this.todayOrders,
    this.weekOrders,
    this.monthOrders,
    this.completedOrders,
    this.pendingOrders,
    this.cancelledOrders,
    this.totalProducts,
    this.activeProducts,
    this.outOfStockProducts,
  });

  ReportData.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue'] != null ? double.parse(json['total_revenue'].toString()) : 0.0;
    todayRevenue = json['today_revenue'] != null ? double.parse(json['today_revenue'].toString()) : 0.0;
    weekRevenue = json['week_revenue'] != null ? double.parse(json['week_revenue'].toString()) : 0.0;
    monthRevenue = json['month_revenue'] != null ? double.parse(json['month_revenue'].toString()) : 0.0;
    totalOrders = json['total_orders'] != null ? int.parse(json['total_orders'].toString()) : 0;
    todayOrders = json['today_orders'] != null ? int.parse(json['today_orders'].toString()) : 0;
    weekOrders = json['week_orders'] != null ? int.parse(json['week_orders'].toString()) : 0;
    monthOrders = json['month_orders'] != null ? int.parse(json['month_orders'].toString()) : 0;
    completedOrders = json['completed_orders'] != null ? int.parse(json['completed_orders'].toString()) : 0;
    pendingOrders = json['pending_orders'] != null ? int.parse(json['pending_orders'].toString()) : 0;
    cancelledOrders = json['cancelled_orders'] != null ? int.parse(json['cancelled_orders'].toString()) : 0;
    totalProducts = json['total_products'] != null ? int.parse(json['total_products'].toString()) : 0;
    activeProducts = json['active_products'] != null ? int.parse(json['active_products'].toString()) : 0;
    outOfStockProducts = json['out_of_stock_products'] != null ? int.parse(json['out_of_stock_products'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_revenue'] = totalRevenue;
    data['today_revenue'] = todayRevenue;
    data['week_revenue'] = weekRevenue;
    data['month_revenue'] = monthRevenue;
    data['total_orders'] = totalOrders;
    data['today_orders'] = todayOrders;
    data['week_orders'] = weekOrders;
    data['month_orders'] = monthOrders;
    data['completed_orders'] = completedOrders;
    data['pending_orders'] = pendingOrders;
    data['cancelled_orders'] = cancelledOrders;
    data['total_products'] = totalProducts;
    data['active_products'] = activeProducts;
    data['out_of_stock_products'] = outOfStockProducts;
    return data;
  }
}
