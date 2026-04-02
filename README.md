# Project Overview
This project is an end-to-end data analytics case study based on a  business scenario for QuickBite, a Nairobi-based food delivery startup testing three ghost kitchens in Kilimani, Westlands, and Eastleigh.

## Business Problem
QuickBite launched ghost kitchens in three Nairobi neighborhoods and now needs to decide whether to:
1. expand to new areas,
2. double down on high-performing locations, or cut underperforming kitchens.

#### A key internal debate centered on Eastleigh:

The CFO argued that Eastleigh had the lowest order volume and should be shut down.
The GM argued that Eastleigh had stronger customer loyalty and growth potential than leadership realized.
This project was designed to go beyond top-line revenue and answer the question using unit economics, operational efficiency, customer behavior, and market context.
   
## Objectives
This analysis aimed to:
1. Evaluate the performance of each ghost kitchen using profitability, growth, and operational metrics.
2. Determine whether QuickBite should expand to a new location.
3. Investigate the true performance story behind Eastleigh.
4. Recommend 3 data-driven menu or operational experiments.
5. Present the findings in a concise, executive-ready format.

## The business needed answers to three core questions:

#### 1. Should QuickBite expand to more ghost kitchen locations?
#### 2. Is Eastleigh actually underperforming, or does it have long-term growth potential?
#### 3. What menu and operational changes should be tested to improve performance?

Using 6 months of operational data, I analyzed orders, revenue, profit, fixed costs, customer ratings, competitor benchmarks, delivery time, weather patterns, and menu performance to uncover what was driving each location’s results.

<img width="1410" height="773" alt="image" src="https://github.com/user-attachments/assets/16626d4c-c200-4962-9360-45ad20a39c5b" />

#### Key Insights

1. Kilimani generated the highest revenue and profit, but had the slowest delivery time, suggesting operational inefficiency despite strong performance.
2. Westlands had the weakest unit economics, with high fixed costs, low profit margin, and declining growth.
3. Eastleigh had the lowest revenue, but it was the only location with consistent growth across all months and the only branch outperforming competitors on customer rating.
4. Eastleigh’s lower revenue was influenced by product mix, as customers ordered more low-priced items such as Pilau, Samosa, and Mandazi.
5. The business was not yet ready to expand, given the overall margin and unresolved performance issues in Westlands.

#### Recommendations
1. Do not expand yet. Improve profitability and operational efficiency first.
2. Do not shut down Eastleigh. Monitor it for an additional 3 months due to its strong growth and customer traction.
3. Prioritize fixing Westlands. Investigate cost reduction, operational inefficiencies, or possible relocation.
4. Test combo meals in Eastleigh to increase average order value.
5. Improve delivery speed across all locations to support ratings and repeat demand.
6. Customize menus by market instead of pushing the same product mix in every neighborhood.

#### The final recommendation was to hold off on expansion, avoid shutting down Eastleigh, and instead focus on fixing Westlands’ weak unit economics while testing targeted menu and delivery improvements.






### Dataset
The case study included 6 months of business data across multiple tables:
* orders_data.csv – order-level transactions, delivery time, ratings, weather flags, order hour
* kitchen_costs.csv – fixed monthly costs by location
* menu_items.csv – item prices, costs, and prep times
* competitor_data.csv – competitive intensity, ratings, and delivery benchmarks
* weather_data.csv – rainfall and temperature data

### Analysis Performed
This project covered the full analytics workflow:
* Business understanding – translated an executive-level business problem into measurable questions
* Data cleaning and preparation – structured multiple datasets for analysis
* Exploratory data analysis – assessed order volume, revenue trends, and operational performance
* Profitability analysis – compared revenue, fixed costs, profit, and profit margins by location
* Growth analysis – examined monthly growth across the three kitchens
* Customer experience analysis – reviewed ratings and delivery performance against competitors
* Menu analysis – identified most ordered items, top revenue items, and AOV opportunities
* Strategic recommendation building – turned analysis into business actions
* Data storytelling – packaged findings into an executive-style presentation/dashboard

#### Tools Used
* Excel – initial review and calculations
* SQL – querying and aggregations
* Power BI – dashboard design and visualization
* PowerPoint – executive presentation


