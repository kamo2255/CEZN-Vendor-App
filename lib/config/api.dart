class DefaultApi {
  // static String baseUrl = "DOMAIN_URL";
  static String baseUrl = "https://cezn.website/";
  static String apiUrl = "${baseUrl}api/";
}

class DemoData {
  static String environment = "Live";
  static String demoEmail = "";
  static String demoPassword = "";
}

class PostApi {
  static String loginApi = "login";
  static String registerApi = "register";
  static String forgotPasswordApi = "forgotpassword";
  static String homeApi = "home";
  static String orderHistoryApi = "orderhistory";
  static String orderDetailsApi = "orderdetail";
  static String updateOrderStatusApi = "statuschange";
  static String updateCustomerDetailsApi = "updatecustomerdetails";
  static String updateVendorNotesApi = "updatevendornote";
  static String updatePaymentStatusApi = "updatepaymentstatus";
  static String editProfileApi = "editprofile";
  static String changePasswordApi = "changepassword";
  static String inquiriesApi = "inquiries";
  static String deleteVendorApi = "deletevendor";
}

class GetApi {
  static String cmsPagesApi = "cmspages";
}