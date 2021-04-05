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

UPDATE
	`covid.oxford_policy_tracker` t0
SET
	t0.mobility = STRUCT<avg_retail FLOAT64
		, avg_grocery FLOAT64
		, avg_parks FLOAT64
		, avg_transit FLOAT64
		, avg_workplace FLOAT64
		, avg_residential FLOAT64>
	(
		t2.avg_retail
		, t2.avg_grocery
		, t2.avg_parks
		, t2.avg_transit
		, t2.avg_workplace
		, t2.avg_residential
	)
FROM
	(
		SELECT
			country_region
			, date
			, AVG(retail_and_recreation_percent_change_from_baseline) as avg_retail
			, AVG(grocery_and_pharmacy_percent_change_from_baseline)  as avg_grocery
			, AVG(parks_percent_change_from_baseline) as avg_parks
			, AVG(transit_stations_percent_change_from_baseline) as avg_transit
			, AVG( workplaces_percent_change_from_baseline ) as avg_workplace
			, AVG( residential_percent_change_from_baseline)  as avg_residential
		FROM
			`bigquery-public-data.covid19_google_mobility.mobility_report`
		GROUP BY
			country_region
			, date
	) AS t2
WHERE
	t0.country_name = t2.country_region
	AND t0.date = t2.date
