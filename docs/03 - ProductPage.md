## Question 3: Product Page  

The product page is a critical part of the e-commerce platform. It serves as the interface where customers browse product details, customize their selections, and add items to their cart.  

---

## UI Presentation (Frontend - PHP & JavaScript)  
The product page is structured as follows:  

1. Product Information Section  
   - Displays product name, description, and base price.  
   - Fetches and loads high-resolution images from AWS S3 (via CloudFront CDN).  
   - Shows average customer reviews (fetched from a `reviews` table).  

2. Customization Options  
   - Customers select different attributes (rim color, frame size, etc.).  
   - Unavailable options are disabled/hidden dynamically.  
   - A real-time price calculator updates the total price based on selections.  

3. Add to Cart Button  
   - Validates selections before adding the product to the cart.  
   - Calls a PHP API endpoint to persist selections.  

---

## Backend - Fetching & Displaying Product Data (PHP & MySQL)  
### Step 1: Fetch Product Details  
A PHP script queries the database to retrieve product information.  

```php
$productId = $_GET['id'];
$sql = "SELECT * FROM products WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([$productId]);
$product = $stmt->fetch();
```

### Step 2: Fetch Available Customization Options  
Options are retrieved based on stock availability.  

```php
$sql = "SELECT o.id, o.name, ov.id AS option_value_id, ov.name AS option_value, ov.price_modifier
        FROM options o
        JOIN option_values ov ON o.id = ov.option_id
        WHERE o.product_id = ? AND ov.in_stock = 1";
$stmt = $pdo->prepare($sql);
$stmt->execute([$productId]);
$options = $stmt->fetchAll();
```

---

## UI - JavaScript Dynamic Updates  
### 1. Hiding Unavailable Options  
```js
document.querySelectorAll(".option-value").forEach(option => {
    if (!option.dataset.inStock) {
        option.classList.add("disabled");  // Grey out unavailable options
    }
});
```

### 2. Real-Time Price Calculation  
As users select options, JavaScript updates the total price.  

```js
function updatePrice() {
    let basePrice = parseFloat(document.getElementById("base-price").textContent);
    let selectedOptions = document.querySelectorAll(".option-value:checked");
    let totalPrice = basePrice;

    selectedOptions.forEach(option => {
        totalPrice += parseFloat(option.dataset.priceModifier);
    });

    document.getElementById("total-price").textContent = totalPrice.toFixed(2);
}
```

This function runs on option selection to ensure a smooth real-time experience.  

---

## Backend - Validating & Calculating Final Price (PHP API)  
Once the user clicks “Add to Cart”, the system calculates the final price server-side to prevent tampering.  

```php
$productId = $_POST['product_id'];
$selectedOptions = $_POST['options']; // Array of selected option IDs

$sql = "SELECT SUM(price_modifier) as extra_cost FROM option_values WHERE id IN (" . implode(",", array_map('intval', $selectedOptions)) . ")";
$stmt = $pdo->query($sql);
$extraCost = $stmt->fetchColumn();

$finalPrice = $basePrice + $extraCost;
```

This ensures the customer is charged correctly even if JavaScript is manipulated.  