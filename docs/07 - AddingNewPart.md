## Question 7: Adding a New Part Choice (New Rim Color)  

If Marcus wants to introduce a new rim color, he needs to:  

1. Select the product (e.g., Carbon Road Bike).  
2. Choose the customization category (e.g., Rim Color).  
3. Add the new color option (e.g., "Blue").  
4. Define pricing (if applicable).  

---

## UI Flow for Adding a New Rim Color
1. Admin Panel > Products > Customization Options  
   - Marcus selects the Carbon Road Bike from a product list.  
   - He navigates to "Rim Color" options.  

2. Add New Option Value  
   - Marcus clicks “Add New Color” and types “Blue.”  
   - If the new color has a price modifier, he enters the additional cost (e.g., $20 extra for Blue rims).  

3. Save Changes  
   - The system updates the database.  
   - The storefront UI will now display Blue as a selectable rim color.

---

## Database Changes
Adding a new rim color means inserting a new row into the `option_values` table.

### Step 1: Find the Option ID for "Rim Color"
```sql
SELECT id FROM options WHERE name = 'Rim Color' AND product_id = 101;
```
Result: Suppose `Rim Color` has `option_id = 203`.

### Step 2: Insert the New Color Option
```sql
INSERT INTO option_values (option_id, name, price_modifier, in_stock)
VALUES (203, 'Blue', 20, 1);
```

| id  | option_id | name  | price_modifier | in_stock |
|-----|----------|-------|---------------|---------|
| 305 | 203      | Black | 0             | 1       |
| 306 | 203      | Red   | 0             | 1       |
| 307 | 203      | Blue  | 20            | 1       |

---

## How the Storefront UI Updates
- When customers view Carbon Road Bike, they now see Black, Red, and Blue as rim color options.  
- If Blue is selected, the price updates dynamically.  

Example JavaScript for Dynamic Price Calculation:
```js
document.getElementById('rimColor').addEventListener('change', function () {
    let selectedColor = this.value;
    fetch(`/api/get-price?productId=101&option=${selectedColor}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('totalPrice').innerText = `$${data.total}`;
        });
});
```

---

## Example PHP Code for Adding a New Rim Color
```php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $productId = $_POST["product_id"];
    $optionName = "Rim Color"; 
    $newColor = $_POST["new_color"];
    $priceModifier = $_POST["price_modifier"];

    // Find the option ID for "Rim Color"
    $stmt = $pdo->prepare("SELECT id FROM options WHERE name = ? AND product_id = ?");
    $stmt->execute([$optionName, $productId]);
    $optionId = $stmt->fetchColumn();

    // Insert the new color into option_values
    $sql = "INSERT INTO option_values (option_id, name, price_modifier, in_stock) 
            VALUES (?, ?, ?, 1)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$optionId, $newColor, $priceModifier]);

    echo "New rim color added successfully!";
}
```