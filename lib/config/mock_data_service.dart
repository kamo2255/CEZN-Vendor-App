/// Mock Data Service for Development Mode
/// This service provides sample data for testing the app without backend APIs
/// Set USE_MOCK_DATA = true to enable mock data mode

class MockDataService {
  // Toggle this to enable/disable mock data
  static const bool USE_MOCK_DATA = true;

  // Mock Reports Data
  static Map<String, dynamic> getMockReports() {
    return {
      "status": "1",
      "message": "Reports fetched successfully",
      "data": {
        "total_revenue": "15000.50",
        "today_revenue": "500.00",
        "week_revenue": "3500.00",
        "month_revenue": "12000.00",
        "total_orders": "250",
        "today_orders": "5",
        "week_orders": "45",
        "month_orders": "180",
        "completed_orders": "200",
        "pending_orders": "30",
        "cancelled_orders": "20",
        "total_products": "150",
        "active_products": "140",
        "out_of_stock_products": "10"
      }
    };
  }

  // Mock Transactions Data
  static Map<String, dynamic> getMockTransactions() {
    return {
      "status": "1",
      "message": "Transactions fetched successfully",
      "data": [
        {
          "id": "1",
          "transaction_id": "TXN-001",
          "order_id": "123",
          "order_number": "#ORD-12345",
          "transaction_type": "Payment",
          "amount": "99.99",
          "payment_method": "Credit Card",
          "payment_status": "Paid",
          "transaction_date": "2025-01-15",
          "notes": "Order payment received",
          "created_at": "2025-01-15 10:30:00"
        },
        {
          "id": "2",
          "transaction_id": "TXN-002",
          "order_id": "124",
          "order_number": "#ORD-12346",
          "transaction_type": "Payment",
          "amount": "149.99",
          "payment_method": "PayPal",
          "payment_status": "Paid",
          "transaction_date": "2025-01-14",
          "notes": "Order payment received",
          "created_at": "2025-01-14 15:20:00"
        },
        {
          "id": "3",
          "transaction_id": "TXN-003",
          "order_id": "125",
          "order_number": "#ORD-12347",
          "transaction_type": "Refund",
          "amount": "49.99",
          "payment_method": "Credit Card",
          "payment_status": "Refunded",
          "transaction_date": "2025-01-13",
          "notes": "Product returned - full refund issued",
          "created_at": "2025-01-13 09:45:00"
        },
        {
          "id": "4",
          "transaction_id": "TXN-004",
          "order_id": "126",
          "order_number": "#ORD-12348",
          "transaction_type": "Payment",
          "amount": "299.99",
          "payment_method": "Debit Card",
          "payment_status": "Paid",
          "transaction_date": "2025-01-12",
          "notes": "Order payment received",
          "created_at": "2025-01-12 14:10:00"
        },
        {
          "id": "5",
          "transaction_id": "TXN-005",
          "order_id": "127",
          "order_number": "#ORD-12349",
          "transaction_type": "Credit",
          "amount": "50.00",
          "payment_method": "Store Credit",
          "payment_status": "Completed",
          "transaction_date": "2025-01-11",
          "notes": "Vendor credit adjustment",
          "created_at": "2025-01-11 11:00:00"
        }
      ]
    };
  }

  // Mock Coupons Data
  static Map<String, dynamic> getMockCoupons() {
    return {
      "status": "1",
      "message": "Coupons fetched successfully",
      "data": [
        {
          "id": "1",
          "code": "SAVE20",
          "description": "20% off on all orders",
          "discount_type": "percentage",
          "discount_value": "20",
          "min_order_amount": "100.00",
          "max_discount_amount": "50.00",
          "usage_limit": "100",
          "used_count": "25",
          "start_date": "2025-01-01",
          "end_date": "2025-12-31",
          "status": "1",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-01 00:00:00"
        },
        {
          "id": "2",
          "code": "WINTER50",
          "description": "50% off winter collection",
          "discount_type": "percentage",
          "discount_value": "50",
          "min_order_amount": "150.00",
          "max_discount_amount": "100.00",
          "usage_limit": "50",
          "used_count": "12",
          "start_date": "2025-01-01",
          "end_date": "2025-03-31",
          "status": "1",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-10 00:00:00"
        },
        {
          "id": "3",
          "code": "FIXED10",
          "description": "Get 10 dollars off",
          "discount_type": "fixed",
          "discount_value": "10",
          "min_order_amount": "50.00",
          "max_discount_amount": "10.00",
          "usage_limit": "200",
          "used_count": "85",
          "start_date": "2025-01-01",
          "end_date": "2025-06-30",
          "status": "1",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-05 00:00:00"
        },
        {
          "id": "4",
          "code": "EXPIRED15",
          "description": "15% off - expired deal",
          "discount_type": "percentage",
          "discount_value": "15",
          "min_order_amount": "75.00",
          "max_discount_amount": "30.00",
          "usage_limit": "75",
          "used_count": "75",
          "start_date": "2024-12-01",
          "end_date": "2024-12-31",
          "status": "0",
          "created_at": "2024-12-01 00:00:00",
          "updated_at": "2024-12-31 00:00:00"
        }
      ]
    };
  }

  // Mock Deals Data
  static Map<String, dynamic> getMockDeals() {
    return {
      "status": "1",
      "message": "Deals fetched successfully",
      "data": [
        {
          "id": "1",
          "product_id": "10",
          "product_name": "Summer Dress",
          "product_image": "https://cezn.website/uploads/products/dress.jpg",
          "deal_title": "Hot Summer Sale",
          "deal_description": "50% off on summer collection",
          "original_price": "100.00",
          "deal_price": "50.00",
          "discount_percentage": "50",
          "available_quantity": "100",
          "sold_count": "25",
          "start_date": "2025-01-01",
          "end_date": "2025-06-30",
          "status": "1",
          "featured": "1",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-01 00:00:00"
        },
        {
          "id": "2",
          "product_id": "11",
          "product_name": "Casual T-Shirt",
          "product_image": "https://cezn.website/uploads/products/tshirt.jpg",
          "deal_title": "Clearance Sale",
          "deal_description": "Get 40% off casual wear",
          "original_price": "50.00",
          "deal_price": "30.00",
          "discount_percentage": "40",
          "available_quantity": "200",
          "sold_count": "85",
          "start_date": "2025-01-01",
          "end_date": "2025-12-31",
          "status": "1",
          "featured": "0",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-05 00:00:00"
        },
        {
          "id": "3",
          "product_id": "12",
          "product_name": "Winter Jacket",
          "product_image": "https://cezn.website/uploads/products/jacket.jpg",
          "deal_title": "Winter Clearance",
          "deal_description": "End of season winter sale",
          "original_price": "200.00",
          "deal_price": "120.00",
          "discount_percentage": "40",
          "available_quantity": "50",
          "sold_count": "15",
          "start_date": "2025-01-01",
          "end_date": "2025-03-31",
          "status": "1",
          "featured": "1",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-01 00:00:00"
        },
        {
          "id": "4",
          "product_id": "13",
          "product_name": "Denim Jeans",
          "product_image": "https://cezn.website/uploads/products/jeans.jpg",
          "deal_title": "Flash Sale - Inactive",
          "deal_description": "Limited time offer on denim",
          "original_price": "80.00",
          "deal_price": "56.00",
          "discount_percentage": "30",
          "available_quantity": "150",
          "sold_count": "45",
          "start_date": "2025-01-01",
          "end_date": "2025-12-31",
          "status": "0",
          "featured": "0",
          "created_at": "2025-01-01 00:00:00",
          "updated_at": "2025-01-08 00:00:00"
        }
      ]
    };
  }

  // Mock Success Response for Add/Update/Delete operations
  static Map<String, dynamic> getMockSuccessResponse(String message) {
    return {
      "status": "1",
      "message": message
    };
  }

  // Mock Error Response
  static Map<String, dynamic> getMockErrorResponse(String message) {
    return {
      "status": "0",
      "message": message
    };
  }
}
