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




/* query New York cab fares for upgrades */
SELECT
	COUNT(fare_amount) AS num_fares
	, MIN(fare_amount) AS low_fare
	, MAX(fare_amount) AS high_fare
	, AVG(fare_amount) AS avg_fare
	, STDDEV(fare_amount) AS stddev
FROM
	`nyc-tlc.yellow.trips`
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
