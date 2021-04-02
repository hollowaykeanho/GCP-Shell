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




/* query data for training */
SELECT
	season
	, round
	, days_from_epoch
	, game_date
	, day
	, 'win' AS label
	, win_seed AS seed
	, win_market AS market
	, win_name AS name
	, win_alias AS alias
	, win_school_ncaa AS school_ncaa
	, lose_seed AS opponent_seed
	, lose_market AS opponent_market
	, lose_name AS opponent_name
	, lose_alias AS opponent_alias
	, lose_school_ncaa AS opponent_school_ncaa
FROM
	`bigquery-public-data.ncaa_basketball.mbb_historical_tournament_games`

UNION ALL

SELECT
	season
	, round
	, days_from_epoch
	, game_date
	, day
	, 'lose' AS label
	, lose_seed AS seed
	, lose_market AS market
	, lose_name AS name
	, lose_alias AS alias
	, lose_school_ncaa AS school_ncaa
	, win_seed AS opponent_seed
	, win_market AS opponent_market
	, win_name AS opponent_name
	, win_alias AS opponent_alias
	, win_school_ncaa AS opponent_school_ncaa
FROM
	`bigquery-public-data.ncaa_basketball.mbb_historical_tournament_games`
