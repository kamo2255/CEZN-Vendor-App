# Backend API Implementation Guide - Laravel

## Complete Laravel API for Product Management

This guide provides all the Laravel backend code needed to support the product management feature in your Flutter vendor app.

---

## 📋 Table of Contents

1. [Database Migrations](#1-database-migrations)
2. [Models](#2-models)
3. [Controllers](#3-controllers)
4. [Routes](#4-routes)
5. [Form Requests (Validation)](#5-form-requests-validation)
6. [Testing the API](#6-testing-the-api)

---

## 1. Database Migrations

### Create Products Table Migration

```bash
php artisan make:migration create_products_table
```

**File: `database/migrations/xxxx_xx_xx_create_products_table.php`**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('vendor_id');
            $table->string('name');
            $table->text('description')->nullable();
            $table->unsignedBigInteger('category_id')->nullable();
            $table->decimal('price', 10, 2);
            $table->decimal('sale_price', 10, 2)->nullable();
            $table->integer('stock')->default(0);
            $table->string('sku')->unique()->nullable();
            $table->boolean('status')->default(1); // 1 = active, 0 = inactive
            $table->boolean('featured')->default(0);
            $table->string('image')->nullable();
            $table->timestamps();

            // Foreign keys
            $table->foreign('vendor_id')->references('id')->on('vendors')->onDelete('cascade');
            $table->foreign('category_id')->references('id')->on('categories')->onDelete('set null');

            // Indexes
            $table->index('vendor_id');
            $table->index('category_id');
            $table->index('status');
        });
    }

    public function down()
    {
        Schema::dropIfExists('products');
    }
};
```

### Create Product Images Table (for multiple images)

```bash
php artisan make:migration create_product_images_table
```

**File: `database/migrations/xxxx_xx_xx_create_product_images_table.php`**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('product_images', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('product_id');
            $table->string('image');
            $table->integer('sort_order')->default(0);
            $table->timestamps();

            $table->foreign('product_id')->references('id')->on('products')->onDelete('cascade');
            $table->index('product_id');
        });
    }

    public function down()
    {
        Schema::dropIfExists('product_images');
    }
};
```

### Create Product Attributes Table

```bash
php artisan make:migration create_product_attributes_table
```

**File: `database/migrations/xxxx_xx_xx_create_product_attributes_table.php`**

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('product_attributes', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('product_id');
            $table->string('name');
            $table->string('value');
            $table->timestamps();

            $table->foreign('product_id')->references('id')->on('products')->onDelete('cascade');
            $table->index('product_id');
        });
    }

    public function down()
    {
        Schema::dropIfExists('product_attributes');
    }
};
```

### Run Migrations

```bash
php artisan migrate
```

---

## 2. Models

### Product Model

```bash
php artisan make:model Product
```

**File: `app/Models/Product.php`**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'vendor_id',
        'name',
        'description',
        'category_id',
        'price',
        'sale_price',
        'stock',
        'sku',
        'status',
        'featured',
        'image',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'sale_price' => 'decimal:2',
        'stock' => 'integer',
        'status' => 'boolean',
        'featured' => 'boolean',
    ];

    // Relationships
    public function vendor()
    {
        return $this->belongsTo(Vendor::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }

    public function attributes()
    {
        return $this->hasMany(ProductAttribute::class);
    }

    // Accessors
    public function getImageUrlAttribute()
    {
        return $this->image ? asset('storage/' . $this->image) : null;
    }

    // Scopes
    public function scopeActive($query)
    {
        return $query->where('status', 1);
    }

    public function scopeForVendor($query, $vendorId)
    {
        return $query->where('vendor_id', $vendorId);
    }
}
```

### ProductImage Model

```bash
php artisan make:model ProductImage
```

**File: `app/Models/ProductImage.php`**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',
        'image',
        'sort_order',
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function getImageUrlAttribute()
    {
        return asset('storage/' . $this->image);
    }
}
```

### ProductAttribute Model

```bash
php artisan make:model ProductAttribute
```

**File: `app/Models/ProductAttribute.php`**

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductAttribute extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',
        'name',
        'value',
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
```

---

## 3. Controllers

### VendorProductController

```bash
php artisan make:controller Api/VendorProductController
```

**File: `app/Http/Controllers/Api/VendorProductController.php`**

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class VendorProductController extends Controller
{
    /**
     * Get all products for the authenticated vendor
     */
    public function products(Request $request)
    {
        try {
            // Get vendor_id from request (sent from Flutter app)
            $vendorId = $request->vendor_id ?? auth()->id();

            $products = Product::with(['category', 'images', 'attributes'])
                ->where('vendor_id', $vendorId)
                ->orderBy('created_at', 'desc')
                ->get()
                ->map(function ($product) {
                    return [
                        'id' => $product->id,
                        'vendor_id' => $product->vendor_id,
                        'name' => $product->name,
                        'description' => $product->description,
                        'category_id' => $product->category_id,
                        'category_name' => $product->category ? $product->category->name : null,
                        'price' => $product->price,
                        'sale_price' => $product->sale_price,
                        'stock' => $product->stock,
                        'sku' => $product->sku,
                        'status' => $product->status ? '1' : '0',
                        'featured' => $product->featured ? '1' : '0',
                        'image' => $product->image ? asset('storage/' . $product->image) : null,
                        'images' => $product->images->pluck('image_url')->toArray(),
                        'attributes' => $product->attributes->map(function ($attr) {
                            return [
                                'name' => $attr->name,
                                'value' => $attr->value,
                            ];
                        }),
                        'created_at' => $product->created_at->toDateTimeString(),
                        'updated_at' => $product->updated_at->toDateTimeString(),
                    ];
                });

            return response()->json([
                'status' => 'success',
                'message' => 'Products fetched successfully',
                'data' => $products,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to fetch products: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get product categories
     */
    public function categories(Request $request)
    {
        try {
            $categories = Category::where('status', 1)
                ->orderBy('name')
                ->get()
                ->map(function ($category) {
                    return [
                        'id' => $category->id,
                        'name' => $category->name,
                        'image' => $category->image ? asset('storage/' . $category->image) : null,
                        'description' => $category->description ?? '',
                    ];
                });

            return response()->json([
                'status' => 'success',
                'message' => 'Categories fetched successfully',
                'data' => $categories,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to fetch categories: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Add a new product
     */
    public function addProduct(Request $request)
    {
        try {
            // Validation
            $validator = Validator::make($request->all(), [
                'name' => 'required|string|max:255',
                'description' => 'nullable|string',
                'category_id' => 'required|exists:categories,id',
                'price' => 'required|numeric|min:0',
                'stock' => 'nullable|integer|min:0',
                'sku' => 'nullable|string|unique:products,sku',
                'status' => 'nullable|in:0,1',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()->first(),
                ], 422);
            }

            // Get vendor_id from request
            $vendorId = $request->vendor_id ?? auth()->id();

            // Handle image upload
            $imagePath = null;
            if ($request->hasFile('image')) {
                $image = $request->file('image');
                $imageName = time() . '_' . $image->getClientOriginalName();
                $imagePath = $image->storeAs('products', $imageName, 'public');
            }

            // Create product
            $product = Product::create([
                'vendor_id' => $vendorId,
                'name' => $request->name,
                'description' => $request->description,
                'category_id' => $request->category_id,
                'price' => $request->price,
                'sale_price' => $request->sale_price,
                'stock' => $request->stock ?? 0,
                'sku' => $request->sku,
                'status' => $request->status ?? 1,
                'featured' => $request->featured ?? 0,
                'image' => $imagePath,
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Product added successfully',
                'data' => $product,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to add product: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Update an existing product
     */
    public function updateProduct(Request $request)
    {
        try {
            // Validation
            $validator = Validator::make($request->all(), [
                'product_id' => 'required|exists:products,id',
                'name' => 'required|string|max:255',
                'description' => 'nullable|string',
                'category_id' => 'required|exists:categories,id',
                'price' => 'required|numeric|min:0',
                'stock' => 'nullable|integer|min:0',
                'sku' => 'nullable|string|unique:products,sku,' . $request->product_id,
                'status' => 'nullable|in:0,1',
                'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()->first(),
                ], 422);
            }

            $product = Product::findOrFail($request->product_id);

            // Verify vendor owns this product
            $vendorId = $request->vendor_id ?? auth()->id();
            if ($product->vendor_id != $vendorId) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Unauthorized action',
                ], 403);
            }

            // Handle image upload
            if ($request->hasFile('image')) {
                // Delete old image
                if ($product->image && Storage::disk('public')->exists($product->image)) {
                    Storage::disk('public')->delete($product->image);
                }

                $image = $request->file('image');
                $imageName = time() . '_' . $image->getClientOriginalName();
                $imagePath = $image->storeAs('products', $imageName, 'public');
                $product->image = $imagePath;
            }

            // Update product
            $product->update([
                'name' => $request->name,
                'description' => $request->description,
                'category_id' => $request->category_id,
                'price' => $request->price,
                'sale_price' => $request->sale_price,
                'stock' => $request->stock ?? 0,
                'sku' => $request->sku,
                'status' => $request->status ?? 1,
                'featured' => $request->featured ?? 0,
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Product updated successfully',
                'data' => $product,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to update product: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Delete a product
     */
    public function deleteProduct(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'product_id' => 'required|exists:products,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()->first(),
                ], 422);
            }

            $product = Product::findOrFail($request->product_id);

            // Verify vendor owns this product
            $vendorId = $request->vendor_id ?? auth()->id();
            if ($product->vendor_id != $vendorId) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Unauthorized action',
                ], 403);
            }

            // Delete product image
            if ($product->image && Storage::disk('public')->exists($product->image)) {
                Storage::disk('public')->delete($product->image);
            }

            // Delete product (cascade will delete images and attributes)
            $product->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Product deleted successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to delete product: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get single product details
     */
    public function productDetail(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'product_id' => 'required|exists:products,id',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'message' => $validator->errors()->first(),
                ], 422);
            }

            $product = Product::with(['category', 'images', 'attributes'])
                ->findOrFail($request->product_id);

            return response()->json([
                'status' => 'success',
                'message' => 'Product details fetched successfully',
                'data' => [
                    'id' => $product->id,
                    'vendor_id' => $product->vendor_id,
                    'name' => $product->name,
                    'description' => $product->description,
                    'category_id' => $product->category_id,
                    'category_name' => $product->category ? $product->category->name : null,
                    'price' => $product->price,
                    'sale_price' => $product->sale_price,
                    'stock' => $product->stock,
                    'sku' => $product->sku,
                    'status' => $product->status ? '1' : '0',
                    'featured' => $product->featured ? '1' : '0',
                    'image' => $product->image ? asset('storage/' . $product->image) : null,
                    'images' => $product->images->pluck('image_url')->toArray(),
                    'attributes' => $product->attributes,
                    'created_at' => $product->created_at->toDateTimeString(),
                    'updated_at' => $product->updated_at->toDateTimeString(),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Failed to fetch product details: ' . $e->getMessage(),
            ], 500);
        }
    }
}
```

---

## 4. Routes

**File: `routes/api.php`**

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\VendorProductController;

// Product Management Routes
Route::post('products', [VendorProductController::class, 'products']);
Route::post('categories', [VendorProductController::class, 'categories']);
Route::post('addproduct', [VendorProductController::class, 'addProduct']);
Route::post('updateproduct', [VendorProductController::class, 'updateProduct']);
Route::post('deleteproduct', [VendorProductController::class, 'deleteProduct']);
Route::post('productdetail', [VendorProductController::class, 'productDetail']);
```

**Note:** Make sure these routes match the base URL `https://cezn.website/api/` that's configured in your Flutter app.

---

## 5. Form Requests (Validation)

### Optional: Create Form Requests for Better Organization

```bash
php artisan make:request StoreProductRequest
php artisan make:request UpdateProductRequest
```

**File: `app/Http/Requests/StoreProductRequest.php`**

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreProductRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'price' => 'required|numeric|min:0',
            'stock' => 'nullable|integer|min:0',
            'sku' => 'nullable|string|unique:products,sku',
            'status' => 'nullable|in:0,1',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ];
    }
}
```

---

## 6. Testing the API

### Using Postman or cURL

#### 1. Get Products

```bash
curl -X POST https://cezn.website/api/products \
  -H "Content-Type: application/json" \
  -d '{"vendor_id": 1}'
```

#### 2. Get Categories

```bash
curl -X POST https://cezn.website/api/categories \
  -H "Content-Type: application/json" \
  -d '{}'
```

#### 3. Add Product

```bash
curl -X POST https://cezn.website/api/addproduct \
  -F "vendor_id=1" \
  -F "name=Test Product" \
  -F "description=This is a test product" \
  -F "category_id=1" \
  -F "price=99.99" \
  -F "stock=10" \
  -F "sku=PROD-001" \
  -F "status=1" \
  -F "image=@/path/to/image.jpg"
```

#### 4. Update Product

```bash
curl -X POST https://cezn.website/api/updateproduct \
  -F "product_id=1" \
  -F "vendor_id=1" \
  -F "name=Updated Product" \
  -F "description=Updated description" \
  -F "category_id=1" \
  -F "price=129.99" \
  -F "stock=15" \
  -F "status=1"
```

#### 5. Delete Product

```bash
curl -X POST https://cezn.website/api/deleteproduct \
  -H "Content-Type: application/json" \
  -d '{"product_id": 1, "vendor_id": 1}'
```

---

## 7. Additional Setup

### Create Symbolic Link for Storage

```bash
php artisan storage:link
```

This creates a symbolic link from `public/storage` to `storage/app/public`, allowing uploaded images to be publicly accessible.

### Update .env File

Make sure your `.env` file has proper filesystem configuration:

```env
FILESYSTEM_DISK=public
```

---

## 8. Sample Category Seeder (Optional)

Create some test categories:

```bash
php artisan make:seeder CategorySeeder
```

**File: `database/seeders/CategorySeeder.php`**

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    public function run()
    {
        $categories = [
            ['name' => 'Electronics', 'status' => 1],
            ['name' => 'Clothing', 'status' => 1],
            ['name' => 'Home & Garden', 'status' => 1],
            ['name' => 'Sports', 'status' => 1],
            ['name' => 'Books', 'status' => 1],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
```

Run the seeder:

```bash
php artisan db:seed --class=CategorySeeder
```

---

## 9. Security Considerations

### Add Middleware for Authentication (if needed)

If you want to protect these routes with authentication:

```php
Route::middleware('auth:sanctum')->group(function () {
    Route::post('products', [VendorProductController::class, 'products']);
    Route::post('addproduct', [VendorProductController::class, 'addProduct']);
    // ... other routes
});
```

---

## 📝 Summary

You now have:

✅ Complete database structure with migrations
✅ Eloquent models with relationships
✅ Full CRUD API controller
✅ API routes matching your Flutter app
✅ Image upload handling
✅ Validation
✅ Error handling

## 🚀 Next Steps:

1. Run migrations: `php artisan migrate`
2. Create storage link: `php artisan storage:link`
3. Add routes to `routes/api.php`
4. Test endpoints with Postman
5. Connect your Flutter app!

The API is ready to work with your Flutter vendor app! 🎉
