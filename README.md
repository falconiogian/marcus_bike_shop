# Marcus Bike Shop - Core Model

This repository contains the core model for the Marcus Bike Shop e-commerce platform using Apache, PHP, and MySQL (deployed on AWS).

## Features
- Domain Models in PHP: Classes representing `Product`, `Option`, `OptionValue`, and `Cart`.
- Database Schema: SQL file for setting up the MySQL database with tables for products, options, option_values, pricing_rules, cart, orders, and users.
- Lightweight Implementation: No frameworks are used, keeping the solution simple and focused on domain logic.

## Trade-offs & Decisions
- Simplicity: Plain PHP and MySQL to keep the solution lightweight. This means less overhead but also fewer built-in security and ORM features.
- Modularity: The domain classes are simple and modular, making it easy to extend or refactor as needed.
- Scalability Considerations: While basic, this model can be extended later to include session management, caching (e.g., using Redis), and enhanced security, especially when deploying on AWS.

## Folder Structure
- `README.md` - This documentation.
- `database/schema.sql` - MySQL schema for database setup.
- `src/` - Contains PHP classes:
  - `Product.php`
  - `Option.php`
  - `OptionValue.php`
  - `Cart.php`

## Setup Instructions
1. Import `database/schema.sql` into your MySQL database.
2. Use the PHP classes in the `src/` directory to interact with the database and implement business logic.
3. Deploy the solution on an Apache server; for production, consider using AWS services (RDS, S3).

