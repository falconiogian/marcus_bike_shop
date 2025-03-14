## Question 5: Administrative Workflows  

Marcus, as the store owner, needs an admin panel to manage products, options, pricing, and orders. Below are the key workflows and their technical implementations.  

---

# Main Administrative Workflows  

### 1. Managing Products (CRUD Operations)  
- Create new products with descriptions, categories, and pricing.  
- Update product details like images, names, or descriptions.  
- Delete products no longer sold.  

#### Implementation (PHP & MySQL)  

Database Changes  
- Inserts or updates records in the `products` table.  

Admin UI  
- A form where Marcus enters product details.  
- A product list with edit and delete options.  

PHP Example: Add a New Product  
```php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = $_POST["name"];
    $description = $_POST["description"];
    $basePrice = $_POST["base_price"];

    $sql = "INSERT INTO products (name, description, base_price) VALUES (?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$name, $description, $basePrice]);

    echo "Product added successfully!";
}
```

---

### 2. Managing Product Customization (Options & Choices)  
- Add new customization options (e.g., colors, materials).  
- Set price modifiers for options (e.g., +$50 for a custom frame).  
- Update availability of specific options.  

Database Changes  
- Inserts into `options` and `option_values` tables.  

Admin UI  
- Dropdown to select a product.  
- Input fields to add new options or update prices.  

Example: Adding a New Option for a Product  
```php
$sql = "INSERT INTO options (product_id, name) VALUES (?, ?)";
$stmt = $pdo->prepare($sql);
$stmt->execute([$productId, "Frame Color"]);
```

---

### 3️. Managing Orders  
- View active orders and their statuses.  
- Update order status (Pending → Shipped → Delivered).  
- Cancel orders if needed.  

Database Changes  
- Updates the `orders` table.  

Admin UI  
- List of orders with status filters.  
- Buttons to change the status.  

Example: Updating Order Status  
```php
$sql = "UPDATE orders SET status = ? WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute(["shipped", $orderId]);
```

---

### 4. Managing Stock Levels  
- View stock levels for each option.  
- Update stock quantities when new inventory arrives.  

Database Changes  
- Updates the `option_values` table.  

Admin UI  
- Input fields to adjust stock quantities.  

Example: Updating Stock Quantity  
```php
$sql = "UPDATE option_values SET in_stock = ? WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([1, $optionId]); // 1 = In Stock, 0 = Out of Stock
```

---

### 5. Setting Pricing Rules for Customization  
- Define price dependencies (e.g., Red frame + Carbon wheels = +$100).  
- Update prices dynamically based on sales or promotions.  

Database Changes  
- Inserts into `pricing_rules` table.  

Admin UI  
- Input fields to enter price rules.  

Example: Adding a Price Rule  
```php
$sql = "INSERT INTO pricing_rules (base_option_value_id, dependent_option_value_id, additional_cost)
        VALUES (?, ?, ?)";
$stmt = $pdo->prepare($sql);
$stmt->execute([$baseOptionId, $dependentOptionId, 100]);
```