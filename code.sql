/* Codecademy Pro Intensive: Learn SQL from Scratch */
/* Capstone Project: Usage Funnels with Warby Parker */
/* Sarah Schofield */
/* Cohort 7/3/18 */


/* Section 1 - Quiz Funnel */
/* Task 1 - survey table */
SELECT *
FROM survey
LIMIT 10;

/* Task 2 - quiz funnel */
SELECT question AS 'Question',
	COUNT(distinct user_id) AS 'No. of distinct users'
FROM survey
GROUP BY 1;


/* Section 2 - Home Try-On Funnel */
/* Task 4 - table analysis */ 
SELECT *
FROM quiz
LIMIT 5;
 
SELECT *
FROM home_try_on
LIMIT 5;
 
SELECT *
FROM purchase
LIMIT 5;

/* Task 5 - create new table */
SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'is_home_try_on',
	h.number_of_pairs,
    p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON q.user_id = p.user_id
limit 10;

/* Task 6 - home try-on funnel analysis */
/* Total conversion: quiz --> purchase */
WITH funnel AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
		h.number_of_pairs,
		p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
		ON q.user_id = h.user_id
	LEFT JOIN purchase p
		ON q.user_id = p.user_id
	)
SELECT COUNT(*) AS 'num_quiz',
	SUM(is_purchase) AS 'num_purchase',
	ROUND(1.0 * SUM(is_purchase) / count(user_id), 3) AS 'quiz to purchase'
FROM funnel;
 
/* Conversion by step: quiz --> try on --> purchase */
WITH funnel AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
		h.number_of_pairs,
		p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
		ON q.user_id = h.user_id
	LEFT JOIN purchase p
		ON q.user_id = p.user_id
	)
SELECT COUNT(*) AS 'num_quiz',
	SUM(is_home_try_on) AS 'num_try_on',
	SUM(is_purchase) AS 'num_purchase',
	ROUND(1.0 * SUM(is_home_try_on) / count(user_id),3) AS 'quiz to home_try_on',
	ROUND(1.0 * SUM(is_purchase) / sum(is_home_try_on),3) AS 'home_try_on to purchase'
FROM funnel;
 
/* Conversion by number of pairs sent (A/B test) */
WITH funnel AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
		h.number_of_pairs,
		p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
		ON q.user_id = h.user_id
	LEFT JOIN purchase p
		ON q.user_id = p.user_id
	)
SELECT number_of_pairs,
	SUM(is_home_try_on) AS 'num_try_on',
	SUM(is_purchase) AS 'num_purchase',
	ROUND(1.0 * SUM(is_purchase) / sum(is_home_try_on),3) AS 'home_try_on to purchase'
FROM funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;


/* Section 3 - Extra analysis */
/* survey table analysis */ 
SELECT question AS 'Question',
	COUNT(DISTINCT response) AS 'No. of response options'
FROM survey
GROUP BY 1
ORDER BY 1;

SELECT question AS 'Question',
	response AS 'Response',
	COUNT(DISTINCT user_id) AS 'No. of distinct users'
FROM survey
GROUP BY 1, 2 
ORDER BY 1, 2;

/* purchase table analysis */
SELECT COUNT(DISTINCT user_id) AS 'Glasses purchased',
	SUM(price) AS 'Total revenue'
FROM purchase;

SELECT model_name AS 'Model',
	price AS 'Price',
	COUNT(*) AS 'Glasses purchased'
FROM purchase
GROUP BY 1
ORDER BY 3 desc;

SELECT product_id AS 'Product ID',
	model_name AS 'Model',
	color AS 'Color',
	price AS 'Price',
	COUNT(*) AS 'Glasses purchased'
FROM purchase
GROUP BY 1
ORDER BY 5 desc;

/* home_try_on and purchase table analysis */
WITH temp AS (
	SELECT *
	FROM purchase p
	LEFT JOIN home_try_on h
		ON p.user_id = h.user_id
	)
SELECT product_id,
	style,
	model_name,
	color,
	number_of_pairs,
	COUNT(*),
	price
FROM temp
GROUP BY 3,4,5
ORDER BY 1, 6 desc;
