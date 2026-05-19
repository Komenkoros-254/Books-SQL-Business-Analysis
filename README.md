# Books SQL Business Analysis

## Project Overview

This project analyzes an  books dataset using **PostgreSQL** and **pgAdmin**. The goal is to use SQL to explore business problems related to book pricing, ratings, category performance, bestseller status, Kindle Unlimited availability, publisher performance, and promotional opportunities.I would like to appreciate and recognize Asaniczka who made this dataset available in kaggle for analysis

The dataset contains book-level information such as title, author, seller/publisher, rating, price, category, publication date, bestseller status, Editor’s Pick status, Goodreads Choice status, and Kindle Unlimited availability.

---

## Business Objective

The main objective of this project is to answer practical business questions that can help an online bookstore or marketplace improve product promotion, pricing strategy, and category-level decision-making.

This analysis focuses on questions such as:

- Which books have the highest ratings?
- Which books provide the best value based on rating and price?
- Which categories have the strongest average ratings?
- Which categories have the most bestsellers?
- Do Kindle Unlimited books perform differently from non-Kindle Unlimited books?
- Which publishers or sellers have the most books and bestsellers?
- Which books should be promoted based on rating, price, and recognition badges?
- Are there missing, duplicate, or invalid values in the dataset?

---

## Dataset Description

The dataset includes the following columns:

| Column | Description |
|---|---|
| `asin` | Unique Amazon product identifier |
| `title` | Book title |
| `author` | Book author |
| `sold_by` | Seller or publisher |
| `img_url` | Product image URL |
| `product_url` | Amazon product URL |
| `stars` | Average star rating |
| `reviews` | Number of reviews |
| `price` | Book price |
| `is_kindle_unlimited` | Whether the book is available on Kindle Unlimited |
| `category_id` | Category identifier |
| `is_best_seller` | Whether the book is marked as a bestseller |
| `is_editors_pick` | Whether the book is an Editor’s Pick |
| `is_goodreads_choice` | Whether the book is a Goodreads Choice |
| `published_date` | Book publication date |
| `category_name` | Book category name |

---

## Tools Used

- PostgreSQL
- pgAdmin
- SQL
- GitHub

---

## Repository Structure

```text
books-sql-business-analysis/
│
├── data/
│   └── books.csv
│
├── sql/
│   └── books_analysis.sql
│
└── README.md
