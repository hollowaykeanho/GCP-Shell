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




/* predict model */
SELECT
	country,
	SUM(predicted_label) as total_predicted_purchases
FROM
	ml.PREDICT(MODEL `bqml_lab.sample_model`, (
		SELECT
			IFNULL(device.operatingSystem, "") AS os
			, device.isMobile AS is_mobile
			, IFNULL(totals.pageviews, 0) AS pageviews
			, IFNULL(geoNetwork.country, "") AS country
		FROM
			`bigquery-public-data.google_analytics_sample.ga_sessions_*`
		WHERE
			_TABLE_SUFFIX BETWEEN '20170701' AND '20170801'
		)
	)
GROUP BY
	country
ORDER BY
	total_predicted_purchases DESC
LIMIT
	10
;
