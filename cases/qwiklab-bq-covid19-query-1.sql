/* Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */




/* Task 1 */
SELECT
	SUM(cumulative_confirmed) AS total_cases_worldwide
FROM
	`bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
	date = "2020-04-15"




/* Task 2 */
SELECT
	COUNT(*) AS count_of_states
FROM (
	SELECT
		subregion1_name AS state,
		SUM(cumulative_deceased) AS death_count
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_name="United States of America"
		AND date='2020-04-10'
		AND subregion1_name IS NOT NULL
	GROUP BY
		subregion1_name
)
WHERE death_count > 100




/* Task 3 */
SELECT
	*
FROM (
	SELECT
		subregion1_name AS state,
		SUM(cumulative_confirmed) AS total_confirmed_cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_name="United States of America"
		AND date='2020-04-10'
		AND subregion1_name IS NOT NULL
	GROUP BY
		subregion1_name
	ORDER BY
		total_confirmed_cases DESC
)
WHERE
	total_confirmed_cases > 1000

/** OR **/
SELECT *
FROM (
	SELECT
		subregion1_name as state
		, sum(cumulative_confirmed) as total_confirmed_cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_code="US"
		AND date='2020-04-10'
		AND subregion1_name is NOT NULL
	GROUP BY
		subregion1_name
	ORDER BY
		total_confirmed_cases DESC
)
WHERE total_confirmed_cases > 1000




/* Task 4 */
SELECT
	SUM(cumulative_confirmed) AS total_confirmed_cases
	, SUM(cumulative_deceased) AS total_deaths
	, (SUM(cumulative_deceased)/SUM(cumulative_confirmed))*100 AS case_fatality_ratio
FROM
	`bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
	country_name="Italy"
	AND date BETWEEN "2020-04-01" AND "2020-04-30"




/* Task 5 */
SELECT
	date
FROM
	`bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
	country_name="Italy"
	AND cumulative_deceased > 10000
ORDER BY
	date
LIMIT 1




/* Task 6 */
WITH india_cases_by_date AS (
	SELECT
		date
		, SUM(cumulative_confirmed) AS cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_name="India"
		AND date between '2020-02-21' and '2020-03-15'
	GROUP BY
		date
	ORDER BY
		date ASC
)
, india_previous_day_comparison AS (
	SELECT
		date
		, cases
		, LAG(cases) OVER(ORDER BY date) AS previous_day
		, cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
	FROM india_cases_by_date
)

SELECT
	COUNT(date)
FROM
	india_previous_day_comparison
WHERE
	net_new_cases = 0




/* Task 7 */
WITH us_cases_by_date AS (
	SELECT
		date
		, SUM(cumulative_confirmed) AS cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_name="United States of America"
		AND date between '2020-03-22' and '2020-04-20'
	GROUP BY
		date
	ORDER BY
		date ASC
)
, us_previous_day_comparison AS (
	SELECT
		date
		, cases
		, LAG(cases) OVER(ORDER BY date) AS previous_day
		, cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
		, (cases - LAG(cases) OVER(ORDER BY date))*100/LAG(cases) OVER(ORDER BY date) AS percentage_increase
	FROM
		us_cases_by_date
)

SELECT
	Date
	, cases AS Confirmed_Cases_On_Day
	, previous_day AS Confirmed_Cases_Previous_Day
	, percentage_increase AS Percentage_Increase_In_Cases
FROM
	us_previous_day_comparison
WHERE
	percentage_increase > 10




/* Task 8 */
WITH cases_by_country AS (
	SELECT
		country_name AS country
		, SUM(cumulative_confirmed) AS cases
		, SUM(cumulative_recovered) AS recovered_cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		date="2020-05-10"
	GROUP BY
		country_name
)
, recovered_rate AS (
	SELECT
		country
		, cases
		, recovered_cases
		, (recovered_cases * 100)/cases AS recovery_rate
	FROM
		cases_by_country
)

SELECT
	country
	, cases AS confirmed_cases
	, recovered_cases
	, recovery_rate
FROM
	recovered_rate
WHERE
	cases > 50000
ORDER BY recovery_rate DESC
LIMIT 10




/* Task 9 */
WITH france_cases AS (
	SELECT
		date
		, SUM(cumulative_confirmed) AS total_cases
	FROM
		`bigquery-public-data.covid19_open_data.covid19_open_data`
	WHERE
		country_name="France"
		AND date IN ('2020-01-24', '2020-05-10')
	GROUP BY
		date
	ORDER BY
		date
)
, summary as (
	SELECT
		total_cases AS first_day_cases
		, LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases
		, DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
	FROM
		france_cases
	LIMIT 1
)

SELECT first_day_cases
	, last_day_cases
	, days_diff
	, POWER(last_day_cases/first_day_cases,1/days_diff)-1 as cdgr
FROM
	summary




/* Task 10 */
SELECT
	date
	, SUM(cumulative_confirmed) AS country_cases
	, SUM(cumulative_deceased) AS country_deaths
FROM
	`bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
	date BETWEEN '2020-03-15' AND '2020-04-30'
	AND country_name='United States of America'
GROUP BY
	date
