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




/* re-train AI model */
CREATE OR REPLACE MODEL taxi.taxifare_model_2
OPTIONS
	(model_type='linear_reg', labels=['total_fare']) AS

WITH params AS (
		SELECT
			1 AS TRAIN,
			2 AS EVAL
	),

	daynames AS (
		SELECT ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'] AS daysofweek
	),

	taxitrips AS (
		SELECT
			(tolls_amount + fare_amount) AS total_fare
			, daysofweek[ORDINAL(EXTRACT(DAYOFWEEK FROM pickup_datetime))] AS dayofweek
			, EXTRACT(HOUR FROM pickup_datetime) AS hourofday
			, SQRT(POW((pickup_longitude - dropoff_longitude),2) + POW(( pickup_latitude - dropoff_latitude), 2)) as dist
			, SQRT(POW((pickup_longitude - dropoff_longitude),2)) as longitude
			, SQRT(POW((pickup_latitude - dropoff_latitude), 2)) as latitude
			, passenger_count AS passengers
		FROM
			`nyc-tlc.yellow.trips`, daynames, params
		WHERE
			trip_distance > 0
			AND fare_amount BETWEEN 6 and 200
			AND pickup_longitude > -75
			AND pickup_longitude < -73
			AND dropoff_longitude > -75
			AND dropoff_longitude < -73
			AND pickup_latitude > 40
			AND pickup_latitude < 42
			AND dropoff_latitude > 40
			AND dropoff_latitude < 42
			AND MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))),1000) = params.TRAIN
	)

SELECT
	*
FROM
	taxitrips
