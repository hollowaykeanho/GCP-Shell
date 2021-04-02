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




/* train the ML model */
CREATE OR REPLACE MODEL
	`bracketology.ncaa_model`
OPTIONS
	( model_type='logistic_reg') AS

SELECT
	season
	, 'win' AS label
	, win_seed AS seed
	, win_school_ncaa AS school_ncaa
	, lose_seed AS opponent_seed
	, lose_school_ncaa AS opponent_school_ncaa
FROM
	`bigquery-public-data.ncaa_basketball.mbb_historical_tournament_games`
WHERE
	season <= 2017

UNION ALL

SELECT
	season
	, 'lose' AS label
	, lose_seed AS seed
	, lose_school_ncaa AS school_ncaa
	, win_seed AS opponent_seed
	, win_school_ncaa AS opponent_school_ncaa
FROM
	`bigquery-public-data.ncaa_basketball.mbb_historical_tournament_games`
WHERE
	season <= 2017
