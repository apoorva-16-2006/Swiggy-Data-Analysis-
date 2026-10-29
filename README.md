# Swiggy-Data-Analysis-
Analyzed 197,401 food orders using Python, Pandas, and SQL Server to identify monthly order trends, top-performing cities and restaurants, popular food categories, customer ratings, and revenue patterns.
# Swiggy Data Analysis | SQL Server & Python

## 📊 Project Overview

This project analyzes Swiggy food-order data to explore customer ordering patterns and business performance. The analysis focuses on order trends, revenue, restaurant performance, popular food categories, customer ratings, and price ranges.

The project uses **SQL Server for data storage and querying** and **Python for data analysis and visualization**.

## 🎯 Objectives

- Analyze total orders and revenue.
- Identify monthly, quarterly, and yearly order trends.
- Compare order volume and revenue across cities and states.
- Identify top-performing restaurants and popular dishes.
- Explore category-wise order distribution.
- Analyze customer ratings and order price ranges.

## 🛠️ Tools & Technologies

- **SQL Server** – Data storage, data transformation, joins, and analytical queries
- **Python** – Data analysis
- **Pandas** – Data cleaning and manipulation
- **Matplotlib** – Data visualization
- **Jupyter Notebook / Google Colab** – Python analysis environment

## 🗂️ Data Model

The project uses a **Star Schema** design.

### Fact Table
- `fact_swiggy_orders`

### Dimension Tables
- `dim_date`
- `dim_location`
- `dim_restaurant`
- `dim_category`
- `dim_dish`

The fact table stores order-related measures and connects to the dimension tables through keys. This structure supports analytical queries across time, location, restaurants, categories, and dishes.

## 📈 Key Analysis & Findings

### Dataset Summary

| Metric | Value |
|---|---:|
| Total Orders | 197,401 |
| Total Revenue | Approximately ₹53 Million |
| Average Order Price | ₹268.50 |
| Average Rating | 4.34 |
| Total Restaurants | 984 |
| Total Locations | 961 |

### Monthly Order Trends
- January recorded the highest monthly order count, with 25,393 orders.
- February recorded the lowest monthly order count, with 23,291 orders.
- August recorded 25,227 orders.
- Monthly order volume remained relatively consistent across the reported period.

### City Performance
- Bengaluru ranked first in order volume, with 20,072 orders.
- Mumbai recorded 10,507 orders.
- Hyderabad recorded 10,308 orders.
- Bengaluru also ranked first in revenue, generating approximately ₹5.46 million.

### Restaurant Revenue
- KFC ranked first among the top 10 restaurants, generating approximately ₹4.25 million.
- McDonald's ranked second, generating approximately ₹3.34 million.
- Pizza Hut ranked third, generating approximately ₹2.13 million.

### Popular Categories & Dishes
- The Recommended category recorded the highest category-wise order count, with 24,097 orders.
- Veg Fried Rice was the most frequently ordered dish in the reported top-dish analysis, with 321 orders.
- Choco Lava Cake followed with 303 orders.

### Customer Ratings
- 4-star ratings accounted for 73.5%.
- 5-star ratings accounted for 22.2%.
- 3-star ratings accounted for 3.5%.
- 2-star ratings accounted for 0.8%.

### Price Range Analysis
- ₹100–199 was the most common order price range.
- ₹200–299 was the second most common.
- ₹500+ had the lowest order count.

## 🔍 Key Insights

- Bengaluru leads in both order volume and revenue among the reported cities.
- KFC is the highest-revenue restaurant in the top 10 list.
- The Recommended category dominates category-wise order counts.
- Most orders fall within the ₹100–299 price range.
- Customer ratings are concentrated in the 4-star and 5-star groups.

## 🚀 Future Scope

- Build an interactive Power BI dashboard.
- Add filters for city, month, category, and restaurant.
- Analyze customer behavior in more detail.
- Explore revenue forecasting and order prediction using Machine Learning.

## 👩‍💻 Author

**Apoorva Jaliminchi**

BCA – AI & Data Analytics

Project: Swiggy Data Analysis

## 📌 Conclusion

This project demonstrates how SQL Server and Python can be used to analyze food-order data and extract meaningful business insights. It explores order trends, city performance, restaurant revenue, popular categories, customer ratings, and price ranges.

The project strengthened practical skills in SQL querying, data modeling, data analysis, and visualization.
