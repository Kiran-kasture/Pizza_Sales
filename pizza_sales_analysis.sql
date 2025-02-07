-- the total number of orders placed.
SELECT COUNT(ORDER_ID) AS TOTAL_ORDERS
FROM ORDERS; 

--total revenue generated from pizza sales.
SELECT SUM(P.PRICE * O.QUANTITY) AS TOTAL_REVENUE
FROM PIZZAS AS P
JOIN ORDER_DETAILS AS O ON P.PIZZA_ID = O.PIZZA_ID;

--highest-priced pizza.
SELECT PIZZA_ID,
	MAX(PRICE) AS HIGHEST_PRICE
FROM PIZZAS
GROUP BY PIZZA_ID
ORDER BY HIGHEST_PRICE DESC
LIMIT 1 ; 

--most common pizza size ordered.
SELECT P.SIZE,
	COUNT(O.ORDER_DETAILS_ID) AS TOTAL_NO_OF_ORDERS
FROM ORDER_DETAILS AS O
JOIN PIZZAS AS P ON O.PIZZA_ID = P.PIZZA_ID
GROUP BY SIZE
ORDER BY TOTAL_NO_OF_ORDERS DESC; 

 --top 5 most ordered pizza types along with their quantities.
SELECT PIZZA_TYPES.NAME,
	COUNT(ORDER_DETAILS.QUANTITY) AS TOTAL_QUANTITY
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY NAME
ORDER BY TOTAL_QUANTITY DESC
LIMIT 5 ;

--total quantity of each pizza category ordered.
SELECT PIZZA_TYPES.CATEGORY,
COUNT(ORDER_DETAILS.QUANTITY) AS TOTAL_ORDER_QUANTITY
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY CATEGORY
ORDER BY TOTAL_ORDER_QUANTITY DESC; 

 --distribution of orders by hour of the day.
SELECT EXTRACT(HOUR
FROM TIME) AS HOURS,
COUNT(ORDER_ID)
FROM ORDERS
GROUP BY EXTRACT(HOUR FROM TIME);

--top 3 most ordered pizza types based on revenue.
SELECT PIZZA_TYPES.NAME,
ROUND(SUM(PIZZAS.PRICE * ORDER_DETAILS.QUANTITY),0) 
AS TOTAL_REVENUE
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY NAME
ORDER BY TOTAL_REVENUE DESC limit 3;

-- percentage contribution of each pizza type to total revenue.
WITH T_Revenue AS (
    SELECT SUM(PIZZAS.PRICE * ORDER_DETAILS.QUANTITY) AS revenue
    FROM PIZZA_TYPES
    JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
    JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
),
Pizza_Revenue AS (
    SELECT PIZZA_TYPES.category,
           ROUND(SUM(PIZZAS.PRICE * ORDER_DETAILS.QUANTITY), 0) AS TOTAL_REVENUE
    FROM PIZZA_TYPES
    JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
    JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
    GROUP BY PIZZA_TYPES.category
)
SELECT PR.category,
       PR.TOTAL_REVENUE,
       ROUND((PR.TOTAL_REVENUE / TR.revenue) * 100, 2) AS PercentageContribution
FROM Pizza_Revenue PR
CROSS JOIN T_Revenue TR order by PercentageContribution desc;

--cumulative revenue generated over time.

select date ,SUM(PIZZAS.PRICE * ORDER_DETAILS.QUANTITY) as TOTAL_REVENUE
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
JOIN ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID  
join  orders on orders.order_id=order_details.order_id 
group by date order by date;
 
 


