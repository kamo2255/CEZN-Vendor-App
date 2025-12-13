# CEZN Vendor App - Complete API Specification

## Base URL
```
https://cezn.website/api/
```

## Authentication
All API requests should include vendor authentication. The app sends `vendor_id` in the request body.

---

## 📦 Product Management APIs

### 1. Get All Products
**Endpoint:** `POST /products`

**Request:**
```json
{
  "vendor_id": "123"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Products fetched successfully",
  "data": [
    {
      "id": "1",
      "vendor_id": "123",
      "name": "Product Name",
      "description": "Product Description",
      "category_id": "5",
      "category_name": "Category Name",
      "price": "99.99",
      "sale_price": "79.99",
      "stock": "50",
      "sku": "PROD-001",
      "status": "1",
      "featured": "0",
      "image": "https://cezn.website/uploads/products/image.jpg",
      "images": [],
      "attributes": [],
      "created_at": "2025-01-01 00:00:00",
      "updated_at": "2025-01-01 00:00:00"
    }
  ]
}
```

### 2. Add Product
**Endpoint:** `POST /addproduct`

**Request:** (multipart/form-data)
```
vendor_id: 123
name: Product Name
description: Product Description
category_id: 5
price: 99.99
stock: 50
sku: PROD-001
status: 1 (active) or 0 (inactive)
image: [file]
```

**Response:**
```json
{
  "status": "1",
  "message": "Product added successfully"
}
```

### 3. Update Product
**Endpoint:** `POST /updateproduct`

**Request:** (multipart/form-data)
```
vendor_id: 123
product_id: 1
name: Updated Product Name
description: Updated Description
category_id: 5
price: 89.99
stock: 45
sku: PROD-001
status: 1
image: [file] (optional)
```

**Response:**
```json
{
  "status": "1",
  "message": "Product updated successfully"
}
```

### 4. Delete Product
**Endpoint:** `POST /deleteproduct`

**Request:**
```json
{
  "vendor_id": "123",
  "product_id": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Product deleted successfully"
}
```

### 5. Get Product Categories
**Endpoint:** `POST /categories`

**Request:**
```json
{}
```

**Response:**
```json
{
  "status": "1",
  "message": "Categories fetched successfully",
  "data": [
    {
      "id": "1",
      "name": "Category Name",
      "image": "https://cezn.website/uploads/categories/cat.jpg",
      "description": "Category Description"
    }
  ]
}
```

---

## 📊 Reports & Analytics APIs

### 6. Get Reports
**Endpoint:** `POST /reports`

**Request:**
```json
{
  "vendor_id": "123"
}
```

**Response:**
```json
{
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
}
```

---

## 💳 Transactions APIs

### 7. Get Transactions
**Endpoint:** `POST /transactions`

**Request:**
```json
{
  "vendor_id": "123"
}
```

**Response:**
```json
{
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
    }
  ]
}
```

**Transaction Types:**
- `Payment` - Customer payment
- `Refund` - Refund to customer
- `Credit` - Credit to vendor account
- `Debit` - Debit from vendor account

---

## 🎟️ Coupons Management APIs

### 8. Get All Coupons
**Endpoint:** `POST /coupons`

**Request:**
```json
{
  "vendor_id": "123"
}
```

**Response:**
```json
{
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
    }
  ]
}
```

**Discount Types:**
- `percentage` - Percentage discount (e.g., 20%)
- `fixed` - Fixed amount discount (e.g., $10)

### 9. Add Coupon
**Endpoint:** `POST /addcoupon`

**Request:**
```json
{
  "vendor_id": "123",
  "code": "SAVE20",
  "description": "20% off on all orders",
  "discount_type": "percentage",
  "discount_value": "20",
  "min_order_amount": "100.00",
  "max_discount_amount": "50.00",
  "usage_limit": "100",
  "start_date": "2025-01-01",
  "end_date": "2025-12-31",
  "status": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Coupon added successfully"
}
```

### 10. Update Coupon
**Endpoint:** `POST /updatecoupon`

**Request:**
```json
{
  "vendor_id": "123",
  "coupon_id": "1",
  "code": "SAVE25",
  "description": "25% off on all orders",
  "discount_type": "percentage",
  "discount_value": "25",
  "min_order_amount": "100.00",
  "max_discount_amount": "50.00",
  "usage_limit": "150",
  "start_date": "2025-01-01",
  "end_date": "2025-12-31",
  "status": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Coupon updated successfully"
}
```

### 11. Delete Coupon
**Endpoint:** `POST /deletecoupon`

**Request:**
```json
{
  "vendor_id": "123",
  "coupon_id": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Coupon deleted successfully"
}
```

---

## 🔥 Top Deals Management APIs

### 12. Get All Deals
**Endpoint:** `POST /deals`

**Request:**
```json
{
  "vendor_id": "123"
}
```

**Response:**
```json
{
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
      "end_date": "2025-01-31",
      "status": "1",
      "featured": "1",
      "created_at": "2025-01-01 00:00:00",
      "updated_at": "2025-01-01 00:00:00"
    }
  ]
}
```

### 13. Add Deal
**Endpoint:** `POST /adddeal`

**Request:**
```json
{
  "vendor_id": "123",
  "product_id": "10",
  "deal_title": "Hot Summer Sale",
  "deal_description": "50% off on summer collection",
  "original_price": "100.00",
  "deal_price": "50.00",
  "discount_percentage": "50",
  "available_quantity": "100",
  "start_date": "2025-01-01",
  "end_date": "2025-01-31",
  "status": "1",
  "featured": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Deal added successfully"
}
```

### 14. Update Deal
**Endpoint:** `POST /updatedeal`

**Request:**
```json
{
  "vendor_id": "123",
  "deal_id": "1",
  "product_id": "10",
  "deal_title": "Updated Summer Sale",
  "deal_description": "60% off on summer collection",
  "original_price": "100.00",
  "deal_price": "40.00",
  "discount_percentage": "60",
  "available_quantity": "80",
  "start_date": "2025-01-01",
  "end_date": "2025-01-31",
  "status": "1",
  "featured": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Deal updated successfully"
}
```

### 15. Delete Deal
**Endpoint:** `POST /deletedeal`

**Request:**
```json
{
  "vendor_id": "123",
  "deal_id": "1"
}
```

**Response:**
```json
{
  "status": "1",
  "message": "Deal deleted successfully"
}
```

---

## 🔄 Existing APIs (Already Implemented)

### Home Dashboard
**Endpoint:** `POST /home`

### Orders
**Endpoint:** `POST /orderhistory`
**Endpoint:** `POST /orderdetail`
**Endpoint:** `POST /statuschange`

### Profile
**Endpoint:** `POST /editprofile`
**Endpoint:** `POST /changepassword`

---

## 📋 Implementation Checklist

### ✅ Already Working:
- [ ] POST /login
- [ ] POST /home
- [ ] POST /orderhistory
- [ ] POST /orderdetail
- [ ] POST /statuschange
- [ ] POST /editprofile
- [ ] POST /changepassword

### 🆕 Need to Implement:

#### Products (5 endpoints):
- [ ] POST /products
- [ ] POST /addproduct
- [ ] POST /updateproduct
- [ ] POST /deleteproduct
- [ ] POST /categories

#### Reports & Transactions (2 endpoints):
- [ ] POST /reports
- [ ] POST /transactions

#### Coupons (4 endpoints):
- [ ] POST /coupons
- [ ] POST /addcoupon
- [ ] POST /updatecoupon
- [ ] POST /deletecoupon

#### Deals (4 endpoints):
- [ ] POST /deals
- [ ] POST /adddeal
- [ ] POST /updatedeal
- [ ] POST /deletedeal

**Total New Endpoints Required: 15**

---

## 🔒 Security Considerations

1. **Vendor Authentication:**
   - Validate vendor_id for all requests
   - Ensure vendors can only access/modify their own data
   - Implement proper session/token management

2. **Data Validation:**
   - Validate all input data (prices, dates, quantities)
   - Sanitize text inputs to prevent SQL injection
   - Validate file uploads (type, size, format)

3. **Business Logic:**
   - Check product stock before creating deals
   - Validate coupon codes are unique
   - Ensure dates are logical (start_date < end_date)
   - Prevent negative prices or quantities

4. **Image Upload:**
   - Validate image formats (JPG, PNG, WebP)
   - Limit file size (e.g., 5MB max)
   - Generate unique filenames
   - Store in appropriate directories
   - Return full URLs in responses

---

## 📝 Database Schema Suggestions

### Products Table
```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2),
    stock INT DEFAULT 0,
    sku VARCHAR(100),
    status TINYINT DEFAULT 1,
    featured TINYINT DEFAULT 0,
    image VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Coupons Table
```sql
CREATE TABLE coupons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    min_order_amount DECIMAL(10,2) DEFAULT 0,
    max_discount_amount DECIMAL(10,2),
    usage_limit INT DEFAULT 0,
    used_count INT DEFAULT 0,
    start_date DATE,
    end_date DATE,
    status TINYINT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Deals Table
```sql
CREATE TABLE deals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    product_id INT NOT NULL,
    deal_title VARCHAR(255),
    deal_description TEXT,
    original_price DECIMAL(10,2) NOT NULL,
    deal_price DECIMAL(10,2) NOT NULL,
    discount_percentage INT,
    available_quantity INT DEFAULT 0,
    sold_count INT DEFAULT 0,
    start_date DATE,
    end_date DATE,
    status TINYINT DEFAULT 1,
    featured TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### Transactions Table
```sql
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    order_id INT,
    order_number VARCHAR(50),
    transaction_type ENUM('Payment', 'Refund', 'Credit', 'Debit'),
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20),
    transaction_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🧪 Testing Endpoints

You can test the APIs using tools like:
- **Postman** - https://www.postman.com/
- **Insomnia** - https://insomnia.rest/
- **cURL** - Command line tool

### Example cURL Request:
```bash
curl -X POST https://cezn.website/api/products \
  -H "Content-Type: application/json" \
  -d '{"vendor_id": "123"}'
```

---

## 📞 Support

For API implementation questions or issues:
1. Check this specification document
2. Review the app's model files for exact field names
3. Test with sample data first
4. Ensure all responses match the expected JSON structure

---

## 🎯 Priority Order for Implementation

1. **High Priority** (Core functionality):
   - Products APIs (all 5 endpoints)
   - Categories API

2. **Medium Priority** (Business insights):
   - Reports API
   - Transactions API

3. **Low Priority** (Marketing features):
   - Coupons APIs (all 4 endpoints)
   - Deals APIs (all 4 endpoints)

**Note:** All features are already implemented in the mobile app and ready to use once the backend APIs are available!
