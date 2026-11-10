DROP VIEW IF EXISTS dm_v26_nps_states;
CREATE VIEW dm_v26_nps_states AS
SELECT purchase_month AS month, -- месяц покупки
       customer_state AS state, -- код штата покупателя
       state_name, -- название штата
       region, -- регион
       state_lat, -- широта центра штата
       state_lng, -- долгота центра штата
       COUNT(*) AS responses,  -- ответы
       SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) AS promoters, -- промоутеры: 5 звёзд
       SUM(CASE WHEN review_score = 4 THEN 1 ELSE 0 END) AS passives, -- нейтралы: 4 звезды
       SUM(CASE WHEN review_score <= 3 THEN 1 ELSE 0 END) AS detractors, -- критики: 1–3 звезды
       SUM(review_score) AS score_sum, -- сумма оценок
       SUM(is_late) AS late_orders, -- сколько оценённых заказов пришли позже
       ROUND(SUM(delivery_days), 2) AS delivery_days_sum -- сумма дней доставки
FROM core_order
WHERE order_status = 'delivered' -- только доставленнные заказы
  AND review_score IS NOT NULL -- заказы с отзывом
  AND purchase_month BETWEEN '2017-01-01' AND '2018-08-01' --период
GROUP BY purchase_month, customer_state, state_name, region, state_lat, state_lng;
