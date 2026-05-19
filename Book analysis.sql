
/* ============================================================
   Amazon Books Dataset SQL Analysis
   Database: PostgreSQL
   Tool: pgAdmin
   Purpose: Analyze book pricing, ratings, bestsellers, categories,
            Kindle Unlimited performance, publishers, and promotion opportunities.
   ============================================================ */


-- ============================================================
-- 1. Create Table
-- ============================================================

DROP TABLE IF EXISTS books;

CREATE TABLE books (
    asin VARCHAR(20) PRIMARY KEY,
    title TEXT,
    author TEXT,
    sold_by TEXT,
    img_url TEXT,
    product_url TEXT,
    stars NUMERIC(2,1),
    reviews INTEGER,
    price NUMERIC(10,2),
    is_kindle_unlimited BOOLEAN,
    category_id INTEGER,
    is_best_seller BOOLEAN,
    is_editors_pick BOOLEAN,
    is_goodreads_choice BOOLEAN,
    published_date DATE,
    category_name TEXT
);


-- ============================================================
-- 2. Data Quality Checks
-- ============================================================

-- Check total number of records.
SELECT COUNT(*) AS total_books
FROM books;


-- Check for duplicate ASINs.
-- Note: Since ASIN is the primary key, duplicates cannot exist after successful import.
SELECT 
    asin, 
    COUNT(*) AS duplicate_count
FROM books
GROUP BY asin
HAVING COUNT(*) > 1;


-- Find books with invalid ratings.
SELECT 
    asin, 
    title, 
    stars
FROM books
WHERE stars < 0 
   OR stars > 5;


-- Find books with invalid prices.
SELECT 
    asin, 
    title, 
    price
FROM books
WHERE price < 0;


-- Check missing values in important columns.
SELECT
    COUNT(*) FILTER (WHERE asin IS NULL OR asin = '') AS missing_asin,
    COUNT(*) FILTER (WHERE title IS NULL OR title = '') AS missing_title,
    COUNT(*) FILTER (WHERE author IS NULL OR author = '') AS missing_author,
    COUNT(*) FILTER (WHERE sold_by IS NULL OR sold_by = '') AS missing_sold_by,
    COUNT(*) FILTER (WHERE stars IS NULL) AS missing_stars,
    COUNT(*) FILTER (WHERE reviews IS NULL) AS missing_reviews,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE published_date IS NULL) AS missing_published_date,
    COUNT(*) FILTER (WHERE category_name IS NULL OR category_name = '') AS missing_category_name
FROM books;


-- ============================================================
-- 3. Basic Dataset Overview
-- ============================================================

-- Average rating and price.
SELECT
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books;


-- Top 20 highest-rated books.
SELECT
    title,
    author,
    stars,
    price,
    category_name
FROM books
WHERE stars IS NOT NULL
ORDER BY stars DESC, price ASC
LIMIT 20;


-- Top 20 most expensive books.
SELECT
    title,
    author,
    price,
    stars,
    category_name
FROM books
WHERE price IS NOT NULL
ORDER BY price DESC
LIMIT 20;


-- Top 20 cheapest books, excluding free books.
SELECT
    title,
    author,
    price,
    stars,
    category_name
FROM books
WHERE price > 0
ORDER BY price ASC
LIMIT 20;


-- ============================================================
-- 4. Category-Level Analysis
-- ============================================================

-- Average price and rating by category.
SELECT
    category_name,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books
GROUP BY category_name
ORDER BY average_rating DESC;


-- Categories with the most bestsellers.
SELECT
    category_name,
    COUNT(*) AS total_books,
    COUNT(*) FILTER (WHERE is_best_seller = TRUE) AS bestseller_count,
    ROUND(
        COUNT(*) FILTER (WHERE is_best_seller = TRUE) * 100.0 / COUNT(*),
        2
    ) AS bestseller_percentage
FROM books
GROUP BY category_name
ORDER BY bestseller_count DESC;


-- ============================================================
-- 5. Bestseller Analysis
-- ============================================================

-- Compare bestsellers vs non-bestsellers.
SELECT
    is_best_seller,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books
GROUP BY is_best_seller
ORDER BY is_best_seller DESC;


-- Bestselling books with high ratings.
SELECT
    title,
    author,
    stars,
    price,
    category_name
FROM books
WHERE is_best_seller = TRUE
ORDER BY stars DESC, price ASC;


-- ============================================================
-- 6. Kindle Unlimited Analysis
-- ============================================================

-- Kindle Unlimited vs non-Kindle Unlimited.
SELECT
    is_kindle_unlimited,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price,
    COUNT(*) FILTER (WHERE is_best_seller = TRUE) AS bestseller_count
FROM books
GROUP BY is_kindle_unlimited
ORDER BY is_kindle_unlimited DESC;


-- Best Kindle Unlimited books.
SELECT
    title,
    author,
    stars,
    price,
    category_name
FROM books
WHERE is_kindle_unlimited = TRUE
ORDER BY stars DESC, price ASC
LIMIT 20;


-- ============================================================
-- 7. Author and Publisher Analysis
-- ============================================================

-- Top authors by average rating.
SELECT
    author,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books
WHERE author IS NOT NULL
GROUP BY author
HAVING COUNT(*) >= 2
ORDER BY average_rating DESC, total_books DESC;


-- Top sellers or publishers by number of books.
SELECT
    sold_by,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books
WHERE sold_by IS NOT NULL
GROUP BY sold_by
ORDER BY total_books DESC;


-- Sellers with the most bestsellers.
SELECT
    sold_by,
    COUNT(*) AS total_books,
    COUNT(*) FILTER (WHERE is_best_seller = TRUE) AS bestseller_count,
    ROUND(AVG(stars), 2) AS average_rating
FROM books
WHERE sold_by IS NOT NULL
GROUP BY sold_by
ORDER BY bestseller_count DESC, average_rating DESC;


-- ============================================================
-- 8. Editor’s Pick and Goodreads Choice Analysis
-- ============================================================

-- Compare special recognition groups.
SELECT
    COUNT(*) FILTER (WHERE is_best_seller = TRUE) AS bestsellers,
    COUNT(*) FILTER (WHERE is_editors_pick = TRUE) AS editors_picks,
    COUNT(*) FILTER (WHERE is_goodreads_choice = TRUE) AS goodreads_choices
FROM books;


-- Books with any special recognition.
SELECT
    title,
    author,
    stars,
    price,
    category_name,
    is_best_seller,
    is_editors_pick,
    is_goodreads_choice
FROM books
WHERE is_best_seller = TRUE
   OR is_editors_pick = TRUE
   OR is_goodreads_choice = TRUE
ORDER BY stars DESC, price ASC;


-- ============================================================
-- 9. Publication Date Analysis
-- ============================================================

-- Books published by year.
SELECT
    EXTRACT(YEAR FROM published_date) AS publication_year,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price
FROM books
WHERE published_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM published_date)
ORDER BY publication_year DESC;


-- Newest books.
SELECT
    title,
    author,
    published_date,
    stars,
    price,
    category_name
FROM books
WHERE published_date IS NOT NULL
ORDER BY published_date DESC
LIMIT 20;


-- Older books that still have high ratings.
SELECT
    title,
    author,
    published_date,
    stars,
    price
FROM books
WHERE published_date < DATE '2015-01-01'
  AND stars >= 4.5
ORDER BY stars DESC, published_date ASC;


-- ============================================================
-- 10. Pricing Strategy Analysis
-- ============================================================

-- Price segments.
SELECT
    CASE
        WHEN price < 5 THEN 'Budget: Under $5'
        WHEN price >= 5 AND price < 40 THEN 'Low: $5 - $39.99'
        WHEN price >= 40 AND price < 70 THEN 'Medium: $40 - $69.99'
        WHEN price >= 70 AND price < 120 THEN 'High: $70 - $119.99'
        ELSE 'Premium: $120+'
    END AS price_segment,
    COUNT(*) AS total_books,
    ROUND(AVG(stars), 2) AS average_rating,
    ROUND(AVG(price), 2) AS average_price,
    COUNT(*) FILTER (WHERE is_best_seller = TRUE) AS bestseller_count
FROM books
WHERE price IS NOT NULL
GROUP BY price_segment
ORDER BY total_books DESC;


-- Best value books.
-- This query finds books with high ratings and relatively low prices.
SELECT
    title,
    author,
    stars,
    price,
    ROUND(stars / NULLIF(price, 0), 2) AS value_score,
    category_name
FROM books
WHERE stars IS NOT NULL
  AND price IS NOT NULL
  AND price > 0
ORDER BY value_score DESC
LIMIT 20;


-- ============================================================
-- 11. Recommendation Query for Business Use
-- ============================================================

-- Books the store should promote.
-- This identifies books with strong ratings, low or moderate prices, and special recognition.
SELECT
    title,
    author,
    stars,
    price,
    category_name,
    is_best_seller,
    is_editors_pick,
    is_goodreads_choice,
    CASE
        WHEN is_best_seller = TRUE THEN 3
        ELSE 0
    END +
    CASE
        WHEN is_editors_pick = TRUE THEN 2
        ELSE 0
    END +
    CASE
        WHEN is_goodreads_choice = TRUE THEN 2
        ELSE 0
    END +
    CASE
        WHEN stars >= 4.7 THEN 3
        WHEN stars >= 4.5 THEN 2
        ELSE 1
    END +
    CASE
        WHEN price < 10 THEN 2
        WHEN price BETWEEN 10 AND 15 THEN 1
        ELSE 0
    END AS promotion_score
FROM books
WHERE stars >= 4.3
ORDER BY promotion_score DESC, stars DESC, price ASC
LIMIT 25;
