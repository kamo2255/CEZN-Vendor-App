#!/bin/bash

# Fix products_page.dart
sed -i '' 's/AppColors\./FashionHubColors./g' lib/pages/product_pages/products_page.dart
sed -i '' 's/AppFonts\./boldFont.copyWith(/g' lib/pages/product_pages/products_page.dart
sed -i '' 's/fontSize: /fontSize: /g' lib/pages/product_pages/products_page.dart
sed -i '' 's/endPoint://' lib/pages/product_pages/products_page.dart
sed -i '' 's/body://' lib/pages/product_pages/products_page.dart

# Fix add_product_page.dart
sed -i '' 's/AppColors\./FashionHubColors./g' lib/pages/product_pages/add_product_page.dart
sed -i '' 's/AppFonts\./boldFont.copyWith(/g' lib/pages/product_pages/add_product_page.dart
sed -i '' 's/endPoint://' lib/pages/product_pages/add_product_page.dart
sed -i '' 's/body://' lib/pages/product_pages/add_product_page.dart
sed -i '' 's/filePath://' lib/pages/product_pages/add_product_page.dart
sed -i '' 's/fileKey://' lib/pages/product_pages/add_product_page.dart

# Fix custom_button.dart
sed -i '' 's/AppColors\./FashionHubColors./g' lib/widgets/custom_button.dart
sed -i '' 's/AppFonts\./boldFont.copyWith(/g' lib/widgets/custom_button.dart

# Fix custom_textfield.dart
sed -i '' 's/AppColors\./FashionHubColors./g' lib/widgets/custom_textfield.dart
sed -i '' 's/AppFonts\./regularFont.copyWith(/g' lib/widgets/custom_textfield.dart

echo "Files fixed!"
