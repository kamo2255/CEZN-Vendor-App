# Mock Data Development Mode - User Guide

## Overview

The CEZN Vendor App now supports **Mock Data Mode**, allowing you to run and test the application **without requiring backend API endpoints**. This is perfect for:

- **Frontend Development**: Test UI and features while backend is being developed
- **Demo Mode**: Showcase the app with realistic sample data
- **Offline Testing**: Test the app without internet connection
- **Development Speed**: No need to wait for backend APIs to be ready

---

## How to Enable/Disable Mock Data

### Enable Mock Data (Default: ENABLED)

Open [lib/config/mock_data_service.dart](lib/config/mock_data_service.dart:11) and set:

```dart
static const bool USE_MOCK_DATA = true;  // Mock data ENABLED
```

### Disable Mock Data (Use Real APIs)

Change the constant to:

```dart
static const bool USE_MOCK_DATA = false;  // Mock data DISABLED - will use real API
```

**That's it!** The app will automatically switch between mock data and real API calls.

---

## What Features Work with Mock Data?

### ✅ Reports Page
- View comprehensive business analytics
- Revenue overview (Total, Today, Week, Month)
- Orders statistics (Total, Pending, Completed, Cancelled)
- Products overview (Total, Active, Out of Stock)
- All data displays with proper currency formatting

### ✅ Transactions Page
- View transaction history with 5 sample transactions
- Different transaction types: Payment, Refund, Credit, Debit
- Transaction details: ID, Order Number, Amount, Payment Method, Status, Date
- Color-coded by type (Green for credits, Red for debits)

### ✅ Coupons Management
- **View Coupons**: See 4 sample coupons (active, inactive, expired)
- **Add Coupon**: Create new coupons (simulated save)
- **Edit Coupon**: Modify existing coupons (simulated update)
- **Delete Coupon**: Remove coupons (simulated deletion)
- All coupon types supported: Percentage and Fixed Amount discounts
- Automatic expiry detection

### ✅ Top Deals Management
- **View Deals**: See 4 sample deals with product images
- **Add Deal**: Create new deals (simulated save)
- **Edit Deal**: Modify existing deals (simulated update)
- **Delete Deal**: Remove deals (simulated deletion)
- Features: Discount calculation, quantity tracking, featured deals
- Automatic expiry detection

---

## Sample Data Included

### Reports Data
```
Total Revenue: $15,000.50
Today's Revenue: $500.00
Week Revenue: $3,500.00
Month Revenue: $12,000.00

Total Orders: 250
Today's Orders: 5
Completed: 200 | Pending: 30 | Cancelled: 20

Total Products: 150
Active: 140 | Out of Stock: 10
```

### Transactions Data
- 5 sample transactions
- Mix of Payment, Refund, and Credit types
- Amounts ranging from $49.99 to $299.99
- Various payment methods: Credit Card, PayPal, Debit Card, Store Credit

### Coupons Data
- **SAVE20**: 20% off, active until Dec 31, 2025 (25/100 used)
- **WINTER50**: 50% off winter collection (12/50 used)
- **FIXED10**: $10 fixed discount (85/200 used)
- **EXPIRED15**: Expired coupon example (75/75 used)

### Deals Data
- **Summer Dress**: 50% off, $100 → $50 (25 sold, 100 available)
- **Casual T-Shirt**: 40% off, $50 → $30 (85 sold, 200 available)
- **Winter Jacket**: 40% off, $200 → $120 (15 sold, 50 available)
- **Denim Jeans**: 30% off, inactive deal example

---

## How It Works

### Behind the Scenes

1. **API Call Check**: Before making any HTTP request, the app checks `MockDataService.USE_MOCK_DATA`
2. **Mock Response**: If enabled, it returns sample data from [lib/config/mock_data_service.dart](lib/config/mock_data_service.dart)
3. **Network Simulation**: Adds a 300-500ms delay to simulate real network latency
4. **Data Parsing**: Mock data uses the same JSON structure as real API responses
5. **UI Update**: The app renders the data exactly as it would with real API data

### Code Example

```dart
Future fetchData() async {
  // Check if mock data is enabled
  if (MockDataService.USE_MOCK_DATA) {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data
    var mockResponse = MockDataService.getMockReports();
    return ReportModel.fromJson(mockResponse);
  }

  // Real API call
  var response = await Dio().post(apiUrl, data: requestData);
  return ReportModel.fromJson(response.data);
}
```

---

## Switching Between Mock and Real APIs

### Development Workflow

1. **Start Development** (Mock Mode ON)
   - Set `USE_MOCK_DATA = true`
   - Build and test all features with sample data
   - No backend required

2. **Backend Integration** (Mixed Mode)
   - Backend implements APIs one by one
   - Test each API individually by setting `USE_MOCK_DATA = false`
   - Keep using mock data for unfinished APIs

3. **Production Ready** (Mock Mode OFF)
   - Set `USE_MOCK_DATA = false`
   - All features now use real APIs
   - Deploy to production

### Quick Toggle Script

You can create a simple script to toggle mock mode:

```bash
# enable_mock_data.sh
sed -i '' 's/USE_MOCK_DATA = false/USE_MOCK_DATA = true/g' lib/config/mock_data_service.dart

# disable_mock_data.sh
sed -i '' 's/USE_MOCK_DATA = true/USE_MOCK_DATA = false/g' lib/config/mock_data_service.dart
```

---

## Customizing Mock Data

You can modify the sample data to match your testing needs:

### Edit Mock Data

Open [lib/config/mock_data_service.dart](lib/config/mock_data_service.dart) and modify the static methods:

```dart
// Change mock reports data
static Map<String, dynamic> getMockReports() {
  return {
    "status": "1",
    "message": "Reports fetched successfully",
    "data": {
      "total_revenue": "25000.00",  // Change values here
      "today_revenue": "1000.00",
      // ... more fields
    }
  };
}
```

### Add More Mock Items

```dart
// Add more coupons
static Map<String, dynamic> getMockCoupons() {
  return {
    "status": "1",
    "message": "Coupons fetched successfully",
    "data": [
      // Existing coupons...
      {
        "id": "5",
        "code": "NEWDEAL",
        "description": "Your new coupon",
        // ... more fields
      }
    ]
  };
}
```

---

## Limitations of Mock Data Mode

### What Doesn't Work in Mock Mode:

1. **Data Persistence**:
   - Changes (add/edit/delete) are not saved
   - Refreshing the page shows original mock data
   - No database storage

2. **Real Product Selection**:
   - Deal creation shows empty product dropdown (no real products loaded)
   - You can still test the UI and save functionality

3. **Authentication**:
   - Still requires vendor login (uses existing auth)
   - Only mocks Reports, Transactions, Coupons, and Deals data

4. **Images**:
   - Product/deal images use placeholder URLs
   - May not load if URLs are invalid

### Workarounds:

- **Testing Add/Edit**: Mock mode simulates successful save operations
- **Testing Deletion**: Mock mode simulates successful deletion and refreshes data
- **Product Selection**: Load real products API while keeping other features in mock mode

---

## Running the App

### With Mock Data (No Backend Needed)

```bash
# 1. Enable mock data (already enabled by default)
# Edit lib/config/mock_data_service.dart: USE_MOCK_DATA = true

# 2. Run the app
flutter run

# 3. Navigate to any of these tabs:
#    - Reports (see analytics)
#    - Transactions (view transaction history)
#    - Coupons (manage coupons)
#    - Top Deals (manage deals)
```

### With Real Backend APIs

```bash
# 1. Disable mock data
# Edit lib/config/mock_data_service.dart: USE_MOCK_DATA = false

# 2. Ensure backend is running at https://cezn.website/api/

# 3. Run the app
flutter run

# 4. App will now make real HTTP requests
```

---

## Testing Checklist

Use this checklist to test all features in mock mode:

### Reports Page
- [ ] View total revenue card
- [ ] View today/week/month revenue
- [ ] View orders statistics
- [ ] View products overview
- [ ] Pull-to-refresh works
- [ ] Currency formatting displays correctly

### Transactions Page
- [ ] View transaction list
- [ ] Scroll through all 5 transactions
- [ ] Verify color coding (green/red)
- [ ] Pull-to-refresh works
- [ ] Empty state (edit mock data to return empty array)

### Coupons Page
- [ ] View all 4 coupons
- [ ] See active/inactive/expired badges
- [ ] Tap to edit coupon
- [ ] Add new coupon (click + button)
- [ ] Delete coupon (confirmation dialog)
- [ ] Pull-to-refresh works

### Top Deals Page
- [ ] View all 4 deals
- [ ] See product images (with fallback)
- [ ] View discount badges
- [ ] Tap to edit deal
- [ ] Add new deal (click + button)
- [ ] Delete deal (confirmation dialog)
- [ ] Pull-to-refresh works

---

## Troubleshooting

### Issue: "Still seeing errors"
**Solution**: Make sure you've set `USE_MOCK_DATA = true` and saved the file. Hot reload may not work - do a full restart:
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Empty data on some pages"
**Solution**: Check that the mock data service is returning data. Add debug prints:
```dart
var mockResponse = MockDataService.getMockReports();
debugPrint("Mock data: $mockResponse");
```

### Issue: "Can't add/edit items"
**Solution**: In mock mode, add/edit operations are simulated. Data won't persist. This is expected behavior.

### Issue: "Product dropdown is empty in Add Deal"
**Solution**: The products list isn't mocked. Either:
1. Load real products by making that specific API call real
2. Or add mock products to the MockDataService

---

## API Specification

When you're ready to connect to real APIs, refer to:
- [API_SPECIFICATION.md](API_SPECIFICATION.md) - Complete API documentation
- Lists all 15 endpoints needed for Reports, Transactions, Coupons, and Deals

---

## Summary

✅ **Mock Data Mode is ENABLED by default**
✅ **All 4 new features (Reports, Transactions, Coupons, Deals) work with mock data**
✅ **No backend required to run and test the app**
✅ **Easy one-line toggle to switch between mock and real data**
✅ **Simulates network delays and real API responses**
✅ **Sample data included for realistic testing**

**You can now run, test, and demo the CEZN Vendor App without waiting for backend APIs!** 🎉

---

## Next Steps

1. **Test the app** with mock data enabled
2. **Backend team** implements APIs following [API_SPECIFICATION.md](API_SPECIFICATION.md)
3. **Gradually switch** from mock to real APIs as they become available
4. **Production deployment** with `USE_MOCK_DATA = false`

Happy Testing! 🚀
