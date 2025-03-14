## Main User Actions in the E-Commerce Website  

This section describes the core user interactions on Marcus’s bike shop e-commerce platform, covering both customers and administrators.  

---

### 1. Browsing Products  
Action: Customers navigate through categories or use a search bar to find products.  
Technical Details:  
- Products are fetched from MySQL (`products` table) and paginated.  
- Optional caching via Redis (AWS ElastiCache) to improve response times.  
- Images can be stored in AWS S3 and served via CloudFront CDN for faster loading.  

---

### 2. Viewing a Product Page  
Action: Customers click on a product to see details and customization options.  
Technical Details:  
- The page loads data from the `products`, `options`, and `option_values` tables.  
- Available customizations are determined by filtering out-of-stock options (`in_stock = FALSE`).  
- The base price is displayed, and a JavaScript function dynamically updates pricing when customers select different options.  

---

### 3. Customizing a Product  
Action: Customers choose attributes like rim color, frame size, tire type, etc.  
Technical Details:  
- Each selection triggers a real-time price update via AJAX (`option_values.price_modifier`).  
- If certain selections affect other options (e.g., selecting a larger frame limits color choices), MySQL joins check `pricing_rules` for valid combinations.  

---

### 4. Adding to Cart  
Action: Customers finalize selections and click "Add to Cart."  
Technical Details:  
- The selected product and customizations are stored in the `cart` table with `options_selected` as a JSON object.  
- The `total_price` is calculated dynamically and stored.  
- AWS SQS (Simple Queue Service) is used to offload cart updates for scalability.  

---

### 5. Viewing & Managing the Cart  
Action: Customers review their selected items, modify quantities, or remove products.  
Technical Details:  
- The cart page retrieves `cart` items for the logged-in user.  
- A REST API (PHP, Apache) provides endpoints for adding/removing items.  
- Price updates are handled dynamically with AJAX.  

---

### 6. Checkout & Payment Processing  
Action: Customers complete their purchase by entering shipping details and paying.  
Technical Details:  
- When a customer clicks “Checkout”, the system:  
  - Creates an order snapshot in the `orders` table.  
  - Moves cart items into an `orders.cart_snapshot` JSON field.  
  - Triggers a payment gateway (Stripe/PayPal) API call.  
  - If successful, updates `orders.status` to "paid" and sends a confirmation email (AWS SES).  

---

### 7. Order Tracking  
Action: Customers track the progress of their order.  
Technical Details:  
- The order status updates dynamically (`orders.status` field).  
- Customers receive email notifications when the status changes.  
- Admins update statuses via the admin dashboard.  

---

### 8. Admin Panel: Managing Products & Orders  
Admins have a separate backend interface for store management.

#### Admin Actions:
1. Add new products → Inserts into `products`, `options`, and `option_values` tables.  
2. Modify product details → Updates `products` and `option_values` tables.  
3. Manage stock levels → Toggles `option_values.in_stock` for availability.  
4. Change pricing rules → Updates `pricing_rules` for custom combinations.  
5. Process orders → Updates `orders.status` (e.g., "shipped").  