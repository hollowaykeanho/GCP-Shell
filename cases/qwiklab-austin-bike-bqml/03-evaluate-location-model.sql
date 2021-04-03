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




SELECT
	SQRT(mean_squared_error) AS root_mean_square_error
	, mean_squared_error
FROM
	ML.EVALUATE(MODEL bike.location_model_v0, (
		SELECT
			start_station_name
			, EXTRACT(HOUR FROM start_time) AS start_hour
			, EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week
			, address AS location
			, duration_minutes
		FROM
			`bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
		JOIN
			`bigquery-public-data.austin_bikeshare.bikeshare_stations` AS stations
		ON
			trips.start_station_name = stations.name
		WHERE
			EXTRACT(YEAR FROM start_time) = 2019)
	)
