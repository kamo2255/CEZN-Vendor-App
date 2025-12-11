// ignore_for_file: prefer_is_empty, unused_local_variable, unnecessary_null_comparison

class Validation {
  static String? validateEmail(
    String value,
  ) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.length <= 0) {
      return "Please enter valid email address";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid email address";
    } else {
      return null;
    }
  }
}
