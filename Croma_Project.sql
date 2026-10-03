/* =========================================================
   CROMA PRODUCT INVENTORY ANALYSIS
   Database: Croma
   Tables: product_inventory, manufacturers
   ========================================================= */


USE Croma;


/* =========================================================
   1. Select the names of all products in the inventory.
   ========================================================= */

SELECT
    product_name
FROM product_inventory;


/* =========================================================
   2. Select the names and prices of all products.
   ========================================================= */

SELECT
    product_name,
    product_price
FROM product_inventory;


/* =========================================================
   3. Display product names using the alias "Name".
   ========================================================= */

SELECT
    product_name AS Name
FROM product_inventory;


/* =========================================================
   4. Products with a price less than or equal to ₹8,000.
   ========================================================= */

SELECT
    product_name,
    product_price
FROM product_inventory
WHERE product_price <= 8000;


/* =========================================================
   5. Products with a price between ₹2,000 and ₹10,000.
   ========================================================= */

SELECT
    product_name,
    product_price
FROM product_inventory
WHERE product_price BETWEEN 2000 AND 10000;


/* =========================================================
   6. Details of products whose manufacturer code is 6.
   ========================================================= */

SELECT
    *
FROM product_inventory
WHERE manufacturer_code = 6;


/* =========================================================
   7. Products manufactured by code 6
      with a price greater than ₹5,000.
   ========================================================= */

SELECT
    *
FROM product_inventory
WHERE manufacturer_code = 6
  AND product_price > 5000;


/* =========================================================
   8. Details of products whose manufacturer code is NOT 6.
   ========================================================= */

SELECT
    *
FROM product_inventory
WHERE manufacturer_code <> 6;


/* =========================================================
   9. Products whose name starts with 'M'.
   ========================================================= */

SELECT
    product_name
FROM product_inventory
WHERE product_name LIKE 'M%';


/* =========================================================
   10. Products whose name starts with 'M' and ends with 'D'.
   ========================================================= */

SELECT
    product_name
FROM product_inventory
WHERE product_name LIKE 'M%D';


/* =========================================================
   11. Products that:
       - start with 'M'
       - end with 'D'
       - have exactly 9 characters between M and D
   ========================================================= */

SELECT
    product_name
FROM product_inventory
WHERE product_name LIKE 'M_________D';


/* =========================================================
   12. Concatenate product name and price into one column.
   ========================================================= */

SELECT
    CONCAT(product_name, ' - ₹', product_price) AS product_with_price
FROM product_inventory;


/* =========================================================
   13. Display product prices in US dollars.
       Conversion rate: ₹80 = $1
   ========================================================= */

SELECT
    product_name,
    product_price,
    ROUND(product_price / 80, 2) AS price_in_dollars
FROM product_inventory;


/* =========================================================
   14. Calculate the average price of all products.
   ========================================================= */

SELECT
    ROUND(AVG(product_price), 2) AS average_price
FROM product_inventory;


/* =========================================================
   15. Calculate the average price of products
       manufactured by manufacturer code 3.
   ========================================================= */

SELECT
    ROUND(AVG(product_price), 2) AS average_price
FROM product_inventory
WHERE manufacturer_code = 3;


/* =========================================================
   16. Calculate the total cost of products
       manufactured by manufacturer code 2.
   ========================================================= */

SELECT
    SUM(product_price) AS total_cost
FROM product_inventory
WHERE manufacturer_code = 2;


/* =========================================================
   17. Count products with a price of ₹5,000 or more.
   ========================================================= */

SELECT
    COUNT(*) AS number_of_products
FROM product_inventory
WHERE product_price >= 5000;


/* =========================================================
   18. Products priced at ₹5,000 or more,
       sorted by price in ascending order.
   ========================================================= */

SELECT
    product_name,
    product_price
FROM product_inventory
WHERE product_price >= 5000
ORDER BY product_price ASC;


/* =========================================================
   19. Display all product and manufacturer information.
   ========================================================= */

SELECT
    p.*,
    m.manufacturer_name
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code;


/* =========================================================
   20. Display product name, price and manufacturer name.
   ========================================================= */

SELECT
    p.product_name,
    p.product_price,
    m.manufacturer_name
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code;


/* =========================================================
   21. Calculate the average price for each manufacturer,
       displaying the manufacturer code.
   ========================================================= */

SELECT
    manufacturer_code,
    ROUND(AVG(product_price), 2) AS average_price
FROM product_inventory
GROUP BY manufacturer_code
ORDER BY manufacturer_code;


/* =========================================================
   22. Calculate the average price for each manufacturer,
       displaying the manufacturer name.
   ========================================================= */

SELECT
    m.manufacturer_name,
    ROUND(AVG(p.product_price), 2) AS average_price
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code
GROUP BY
    m.manufacturer_code,
    m.manufacturer_name
ORDER BY
    m.manufacturer_name;


/* =========================================================
   23. Manufacturers whose average product price
       is greater than or equal to ₹5,000.
   ========================================================= */

SELECT
    m.manufacturer_name,
    ROUND(AVG(p.product_price), 2) AS average_price
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code
GROUP BY
    m.manufacturer_code,
    m.manufacturer_name
HAVING AVG(p.product_price) >= 5000
ORDER BY average_price DESC;


/* =========================================================
   24. Select the cheapest product.
   ========================================================= */

SELECT
    product_name,
    product_price
FROM product_inventory
WHERE product_price = (
    SELECT MIN(product_price)
    FROM product_inventory
);


/* =========================================================
   25. Select each manufacturer's most expensive product.
   ========================================================= */

SELECT
    m.manufacturer_name,
    p.product_name,
    p.product_price
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code
WHERE p.product_price = (
    SELECT MAX(p2.product_price)
    FROM product_inventory AS p2
    WHERE p2.manufacturer_code = p.manufacturer_code
)
ORDER BY
    m.manufacturer_name;


/* =========================================================
   26. Add a new product:
       Product       : Speaker
       Price         : ₹1,000
       Manufacturer  : 10
   ========================================================= */

INSERT INTO product_inventory
    (
        product_code,
        product_name,
        product_price,
        manufacturer_code
    )
VALUES
    (
        21,
        'Speaker',
        1000,
        10
    );


/* Verify the newly inserted product. */

SELECT
    *
FROM product_inventory
WHERE product_code = 21;


/* =========================================================
   27. Update "Speaker" to "Wired Speakers".
   ========================================================= */

UPDATE product_inventory
SET product_name = 'Wired Speakers'
WHERE product_code = 21;


/* Verify the update. */

SELECT
    *
FROM product_inventory
WHERE product_code = 21;


/* =========================================================
   28. Apply a 10% discount to all products.
       This query only displays the discounted price;
       it does NOT modify the original price.
   ========================================================= */

SELECT
    product_name,
    product_price AS original_price,
    ROUND(product_price * 0.90, 2) AS discounted_price
FROM product_inventory;


/* =========================================================
   29. Apply a 10% discount to products priced
       at ₹5,000 or more.
   ========================================================= */

SELECT
    product_name,
    product_price AS original_price,
    ROUND(product_price * 0.90, 2) AS discounted_price
FROM product_inventory
WHERE product_price >= 5000;


/* =========================================================
   30. Display product name, manufacturer name and price,
       sorted by price.
   ========================================================= */

SELECT
    p.product_name,
    m.manufacturer_name,
    p.product_price
FROM product_inventory AS p
INNER JOIN manufacturers AS m
    ON p.manufacturer_code = m.manufacturer_code
ORDER BY
    p.product_price ASC;
