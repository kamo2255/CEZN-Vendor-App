# API Service Usage Guide

This document shows how to use the new `ApiService` class for better error handling and centralized API management.

## Features

✅ Centralized error handling
✅ Automatic request/response logging
✅ Network timeout configuration (30 seconds)
✅ Better error messages for users
✅ Singleton pattern - one instance across the app

## Basic Usage

### 1. Import the service

```dart
import 'package:fashionhub_saas_vendor_flutter_app/services/api_service.dart';
import 'package:fashionhub_saas_vendor_flutter_app/config/api.dart';
```

### 2. Make API Calls

#### Example: Login API (POST request)

**OLD WAY:**
```dart
var map = {
  "email": txtEmail.text,
  "password": txtPassword.text,
  "login_type": "normal",
  "token": fcmToken
};

var response = await Dio().post(
  DefaultApi.apiUrl + PostApi.loginApi,
  data: map
);

if (response.statusCode == 200) {
  responseData = LoginModel.fromJson(response.data);
  // Handle success
}
```

**NEW WAY (Recommended):**
```dart
var map = {
  "email": txtEmail.text,
  "password": txtPassword.text,
  "login_type": "normal",
  "token": fcmToken
};

final apiService = ApiService();
var response = await apiService.post(PostApi.loginApi, map);

if (response != null && response.statusCode == 200) {
  responseData = LoginModel.fromJson(response.data);
  if (responseData!.status.toString() == "1") {
    // Success - user logged in
    Get.to(() => const DashboardPage());
  } else {
    // Show error from API
    DialogBox.dialogBoxControl(description: responseData!.message.toString());
  }
} else {
  // Network error - error message already handled by ApiService
  DialogBox.dialogBoxControl(
    description: response?.data['message'] ?? 'Connection failed'
  );
}
```

#### Example: File Upload (Profile Picture)

**NEW WAY:**
```dart
var formData = FormData.fromMap({
  "vendor_id": vendorId,
  "name": txtName.text,
  "email": txtEmail.text,
  "mobile": txtMobile.text,
  "profile": await MultipartFile.fromFile(
    imagePath,
    filename: imagePath.split("/").last
  )
});

final apiService = ApiService();
var response = await apiService.postFormData(
  PostApi.editProfileApi,
  formData
);

if (response != null && response.statusCode == 200) {
  // Handle success
  responseData = EditProfileModel.fromJson(response.data);
  if (responseData!.status.toString() == "1") {
    // Profile updated successfully
  }
}
```

#### Example: GET Request (CMS Pages)

**NEW WAY:**
```dart
final apiService = ApiService();
var response = await apiService.get(
  GetApi.cmsPagesApi,
  queryParameters: {"page": "privacy-policy"}
);

if (response != null && response.statusCode == 200) {
  responseData = CmsPagesModel.fromJson(response.data);
  // Use the data
}
```

## Error Handling

The `ApiService` automatically handles these errors:

| Error Type | User-Friendly Message |
|-----------|----------------------|
| Connection Timeout | "Connection timeout. Please check your internet connection." |
| Send Timeout | "Send timeout. Please try again." |
| Receive Timeout | "Receive timeout. Please try again." |
| No Internet | "No internet connection. Please check your network." |
| Server Error (500) | "Server error. Please try again later." |
| Not Found (404) | "Resource not found." |
| Unauthorized (401) | "Unauthorized. Please login again." |

## Advanced Features

### 1. Custom Headers (e.g., for authentication token)

```dart
final apiService = ApiService();

// Add authorization token
apiService.updateHeaders({
  'Authorization': 'Bearer your_token_here'
});

// Now all requests will include this header
var response = await apiService.post(PostApi.homeApi, data);
```

### 2. Clear Cache

```dart
final apiService = ApiService();
apiService.clearCache();
```

### 3. Access the underlying Dio instance (for advanced use)

```dart
final apiService = ApiService();
Dio dio = apiService.dio;

// Use dio directly for custom configurations
```

## Benefits Over Direct Dio Usage

1. **Consistent Error Handling**: All errors are handled in one place
2. **Better Logging**: Automatic request/response logging for debugging
3. **User-Friendly Messages**: Errors are translated to readable messages
4. **Timeout Configuration**: Prevents hanging requests
5. **Less Boilerplate**: No need to repeat try-catch blocks everywhere
6. **Singleton Pattern**: One configured instance across the app

## Migration Checklist

To migrate existing pages to use ApiService:

- [ ] Import `ApiService`
- [ ] Replace `Dio()` with `ApiService()`
- [ ] Replace `.post()` with `apiService.post()`
- [ ] Replace `.get()` with `apiService.get()`
- [ ] For file uploads, use `apiService.postFormData()`
- [ ] Remove manual error handling (ApiService handles it)
- [ ] Keep response null checks: `if (response != null)`

## Example: Complete Login Page Migration

See the difference:

**BEFORE:**
```dart
try {
  Loader.showLoading();
  var response = await Dio().post(
    DefaultApi.apiUrl + PostApi.loginApi,
    data: map
  );

  if (response.statusCode == 200) {
    Loader.hideLoading();
    responseData = LoginModel.fromJson(response.data);
    // ... handle response
  } else {
    Loader.hideLoading();
    DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
  }
} catch (e) {
  Loader.hideLoading();
  DialogBox.dialogBoxControl(description: "str_something_wrong".tr);
}
```

**AFTER:**
```dart
Loader.showLoading();

final apiService = ApiService();
var response = await apiService.post(PostApi.loginApi, map);

Loader.hideLoading();

if (response != null && response.statusCode == 200) {
  responseData = LoginModel.fromJson(response.data);

  if (responseData!.status.toString() == "1") {
    // Success - save data and navigate
    pref.setString(vendorIdPreference, responseData!.data!.id.toString());
    Get.to(() => const DashboardPage());
  } else {
    // API returned error
    DialogBox.dialogBoxControl(description: responseData!.message.toString());
  }
} else {
  // Network error - show the error message from ApiService
  DialogBox.dialogBoxControl(
    description: response?.data['message'] ?? 'str_something_wrong'.tr
  );
}
```

## Console Output

When using ApiService, you'll see helpful logs in the console:

```
📤 REQUEST[POST] => PATH: login
📤 Data: {email: test@example.com, password: *****, login_type: normal}
📥 RESPONSE[200] => PATH: login
📥 Data: {status: 1, message: Login successful, data: {...}}
```

Or for errors:
```
❌ ERROR[500] => PATH: login
❌ Message: Server error
🔴 Error: Server error. Please try again later.
```

## Support

For questions or issues, check:
- API configuration: `lib/config/api.dart`
- Service implementation: `lib/services/api_service.dart`
