/* Warby Parker */
/* Sarah Schofield */
/* cohort 7/3 */

/* Task 1 */
 SELECT *
 FROM survey
 LIMIT 10;
 
 /* Task 2 */
 SELECT question as 'Question',
 	COUNT(distinct user_id) as 'Count of distinct users'
 FROM survey
 GROUP BY 1;

 /* Task 4 */ 
 SELECT *
 FROM quiz
 LIMIT 5;
 
 SELECT *
 FROM home_try_on
 LIMIT 5;
 
 SELECT *
 FROM purchase
 LIMIT 5;

 /* Task 5 */
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

 /* Task 6 */
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
	ROUND(1.0 * SUM(is_purchase) / sum(is_home_try_on),3) AS 'home_try_on to purchase',
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
 SELECT COUNT(*) AS 'num_quiz',
	number_of_pairs,
	SUM(is_home_try_on) AS 'num_try_on',
	SUM(is_purchase) AS 'num_purchase',
	ROUND(1.0 * SUM(is_home_try_on) / count(user_id),3) AS 'quiz to home_try_on',
	ROUND(1.0 * SUM(is_purchase) / sum(is_home_try_on),3) AS 'home_try_on to purchase',
 FROM funnel
 WHERE number_of_pairs IS NOT NULL
 GROUP BY number_of_pairs;

