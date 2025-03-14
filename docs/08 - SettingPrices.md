# Question 8: Setting Prices  

Marcus can change prices in two ways:  

1. Modify the price of a specific part (e.g., a new rim color).  
2. Define pricing rules for specific combinations (e.g., choosing a "Blue" rim adds an extra cost when paired with a carbon frame).  

---

## UI Flow for Setting Prices  
### 1. Changing the Price of a Specific Part
- Admin Panel > Products > Customization Options
- Marcus selects a Product (e.g., Carbon Road Bike).  
- He navigates to "Rim Color" and updates the price modifier for "Blue" (e.g., from $20 → $25).  
- Clicks Save Changes.  
- Storefront updates the price dynamically.  

---

### 2. Setting Special Pricing Rules
- Admin Panel > Pricing Rules
- Marcus adds a pricing rule:
  - Condition: If Carbon Frame + Blue Rim is selected  
  - Extra Cost: +$30  
- Clicks Save Changes.  
- The database updates, ensuring dynamic pricing on the storefront.

---

## Database Changes
### 1. Updating the Price of a Specific Part
If Marcus updates the price of the Blue rim, we update the `option_values` table.

```sql
UPDATE option_values
SET price_modifier = 25
WHERE name = 'Blue' AND option_id = (SELECT id FROM options WHERE name = 'Rim Color');
```

---

### 2. Adding a Special Pricing Rule
We add a new pricing rule in the `pricing_rules` table.

```sql
INSERT INTO pricing_rules (base_option_value_id, dependent_option_value_id, additional_cost)
VALUES (
    (SELECT id FROM option_values WHERE name = 'Blue' AND option_id = (SELECT id FROM options WHERE name = 'Rim Color')),
    (SELECT id FROM option_values WHERE name = 'Carbon' AND option_id = (SELECT id FROM options WHERE name = 'Frame')),
    30
);
```

---

## How the Storefront UI Updates  

### Dynamic Price Calculation
The total price is calculated in real-time when the customer selects options.

```js
document.querySelectorAll('.product-option').forEach(option => {
    option.addEventListener('change', function () {
        let selectedOptions = [...document.querySelectorAll('.product-option')]
            .map(opt => opt.value);
        
        fetch(`/api/get-price?productId=101&options=${selectedOptions.join(',')}`)
            .then(response => response.json())
            .then(data => {
                document.getElementById('totalPrice').innerText = `$${data.total}`;
            });
    });
});
```

---

## Example PHP Code for Price Calculation
### 1. Fetching the Base Price
```php
function getBasePrice($productId) {
    global $pdo;
    $stmt = $pdo->prepare("SELECT base_price FROM products WHERE id = ?");
    $stmt->execute([$productId]);
    return $stmt->fetchColumn();
}
```

---

### 2. Calculating Additional Costs Based on User Selections
```php
function calculatePrice($productId, $selectedOptions) {
    global $pdo;
    $totalPrice = getBasePrice($productId);

    // Calculate price modifiers
    foreach ($selectedOptions as $optionId) {
        $stmt = $pdo->prepare("SELECT price_modifier FROM option_values WHERE id = ?");
        $stmt->execute([$optionId]);
        $totalPrice += $stmt->fetchColumn();
    }

    // Apply special pricing rules
    foreach ($selectedOptions as $baseOption) {
        foreach ($selectedOptions as $dependentOption) {
            $stmt = $pdo->prepare("SELECT additional_cost FROM pricing_rules 
                WHERE base_option_value_id = ? AND dependent_option_value_id = ?");
            $stmt->execute([$baseOption, $dependentOption]);
            $extraCost = $stmt->fetchColumn();
            if ($extraCost) {
                $totalPrice += $extraCost;
            }
        }
    }

    return $totalPrice;
}
```