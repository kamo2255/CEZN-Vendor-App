class CmsPageModel {
  dynamic status;
  dynamic message;
  dynamic privecypolicy;
  dynamic termscondition;
  dynamic aboutus;

  CmsPageModel(
      {this.status,
        this.message,
        this.privecypolicy,
        this.termscondition,
        this.aboutus});

  CmsPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    privecypolicy = json['privecypolicy'];
    termscondition = json['termscondition'];
    aboutus = json['aboutus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['privecypolicy'] = privecypolicy;
    data['termscondition'] = termscondition;
    data['aboutus'] = aboutus;
    return data;
  }
}