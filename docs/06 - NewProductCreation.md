## Question 6: New Product Creation  

When Marcus wants to add a new product to his store, he needs to provide specific details. The system should store this data in the database and update related tables accordingly.

---

## Required Information for a New Product
To create a product, Marcus must provide:  

1. Product Name – The name of the bike model (e.g., "Carbon Road Bike").  
2. Description – A detailed description of the product.  
3. Base Price – The starting price of the product.  
4. Category – What type of product it is (e.g., Bicycle, Skis, Surfboards).  
5. Product Image(s) – At least one image for display.  
6. Customization Options – Any optional features like frame material, color, or wheel type.  

---

## Database Changes  

### 1. Insert a new product into the `products` table  
New Row in `products`  

```sql
INSERT INTO products (name, description, base_price, category, image_url)
VALUES ('Carbon Road Bike', 'Lightweight carbon frame road bike', 1200.00, 'bicycle', 'carbon_road_bike.jpg');
```

| id  | name               | description                         | base_price | category | image_url               |
|-----|--------------------|-----------------------------------|------------|----------|-------------------------|
| 101 | Carbon Road Bike  | Lightweight carbon frame road bike | 1200.00    | bicycle  | carbon_road_bike.jpg    |

---

### 2. Insert default options into the `options` table  
Customization features like "Frame Material" or "Wheel Type"  

```sql
INSERT INTO options (product_id, name)
VALUES (101, 'Frame Material'),
       (101, 'Wheel Type'),
       (101, 'Color');
```

| id  | product_id | name           |
|-----|-----------|---------------|
| 201 | 101       | Frame Material |
| 202 | 101       | Wheel Type     |
| 203 | 101       | Color          |

---

### 3. Insert option values into the `option_values` table  
Adding possible choices and price modifiers  

```sql
INSERT INTO option_values (option_id, name, price_modifier, in_stock)
VALUES 
    (201, 'Aluminum Frame', 0, 1),
    (201, 'Carbon Frame', 300, 1),
    (202, 'Standard Wheels', 0, 1),
    (202, 'Aero Wheels', 250, 1),
    (203, 'Black', 0, 1),
    (203, 'Red', 0, 1);
```

| id  | option_id | name            | price_modifier | in_stock |
|-----|----------|-----------------|----------------|---------|
| 301 | 201      | Aluminum Frame   | 0              | 1       |
| 302 | 201      | Carbon Frame     | 300            | 1       |
| 303 | 202      | Standard Wheels  | 0              | 1       |
| 304 | 202      | Aero Wheels      | 250            | 1       |
| 305 | 203      | Black            | 0              | 1       |
| 306 | 203      | Red              | 0              | 1       |

---

## How the Admin UI Works
1. Marcus fills out a form with product details.  
2. The system stores the product in `products`.  
3. Marcus selects options (e.g., Frame Material, Wheel Type).  
4. The system stores options in `options`.  
5. Marcus adds values (e.g., Carbon Frame, Red Color).  
6. The system stores option_values and their price modifiers.  

---

## Example PHP Code for Adding a Product
Backend logic for handling the form submission  

```php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = $_POST["name"];
    $description = $_POST["description"];
    $basePrice = $_POST["base_price"];
    $category = $_POST["category"];
    $imageUrl = $_POST["image_url"];

    // Insert product into database
    $sql = "INSERT INTO products (name, description, base_price, category, image_url) 
            VALUES (?, ?, ?, ?, ?)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$name, $description, $basePrice, $category, $imageUrl]);

    $productId = $pdo->lastInsertId(); // Get the newly inserted product ID

    echo "Product added successfully! ID: " . $productId;
}
```