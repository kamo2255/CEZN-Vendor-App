class EditProfileModel {
 dynamic status;
  dynamic  message;
  dynamic  name;
 dynamic  email;
  dynamic  mobile;
  dynamic  image;
  dynamic  loginType;

 EditProfileModel(
      {this.status,
        this.message,
        this.name,
        this.email,
        this.mobile,
        this.loginType,
        this.image});

 EditProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
    loginType = json['login_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['image'] = image;
    data['login_type'] = loginType;
    return data;
  }
}