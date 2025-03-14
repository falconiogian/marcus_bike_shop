## Question 4: Add to Cart Action  

When a customer clicks the "Add to Cart" button, the system needs to:  

1. Validate the selected product and options.  
2. Calculate the final price based on the base price and any option price modifiers.  
3. Persist the cart data in the database.  
4. Return a response confirming the item was added successfully.  

---

## Frontend Workflow (PHP & JavaScript)  
### Step 1: Customer Selects Options & Clicks “Add to Cart”  
The page gathers the product ID and selected options and sends them via an AJAX request.  

```js
document.getElementById("add-to-cart-btn").addEventListener("click", function() {
    let productId = document.getElementById("product-id").value;
    let selectedOptions = [...document.querySelectorAll(".option-value:checked")].map(opt => opt.value);

    fetch("/api/cart/add.php", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ product_id: productId, options: selectedOptions })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert("Item added to cart!");
        } else {
            alert("Error adding to cart.");
        }
    });
});
```

---

## Backend Workflow (PHP & MySQL)  

### Step 2: Validate the Request  
The backend first checks if the selected product and options exist and are in stock.  

```php
// Decode JSON request
$data = json_decode(file_get_contents("php://input"), true);
$productId = $data['product_id'];
$selectedOptions = $data['options']; // Array of selected option IDs

// Check if product exists
$sql = "SELECT base_price FROM products WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([$productId]);
$product = $stmt->fetch();

if (!$product) {
    echo json_encode(["success" => false, "error" => "Invalid product."]);
    exit;
}
```

---

### Step 3: Calculate Final Price  
The server retrieves the price modifiers from `option_values` and calculates the total.  

```php
$sql = "SELECT SUM(price_modifier) as extra_cost FROM option_values WHERE id IN (" . implode(",", array_map('intval', $selectedOptions)) . ")";
$stmt = $pdo->query($sql);
$extraCost = $stmt->fetchColumn();

$finalPrice = $product['base_price'] + $extraCost;
```

---

### Step 4: Persist Cart Data  
If validation succeeds, the item is stored in the `cart` table.  

#### Insert Cart Entry in MySQL  
```php
$sql = "INSERT INTO cart (user_id, product_id, total_price) VALUES (?, ?, ?)";
$stmt = $pdo->prepare($sql);
$stmt->execute([$_SESSION['user_id'], $productId, $finalPrice]);

$cartId = $pdo->lastInsertId();

// Insert selected options into a separate table
foreach ($selectedOptions as $optionId) {
    $sql = "INSERT INTO cart_options (cart_id, option_id) VALUES (?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$cartId, $optionId]);
}
```