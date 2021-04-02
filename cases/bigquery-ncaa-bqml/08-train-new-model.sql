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
	`bracketology.ncaa_model_updated`
OPTIONS
	( model_type='logistic_reg') AS

SELECT
	season
	, label
	, poss_40min
	, pace_rank
	, pace_rating
	, opp_poss_40min
	, opp_pace_rank
	, opp_pace_rating
	, pace_rank_diff
	, pace_stat_diff
	, pace_rating_diff
	, pts_100poss
	, efficiency_rank
	, efficiency_rating
	, opp_pts_100poss
	, opp_efficiency_rank
	, opp_efficiency_rating
	, eff_rank_diff
	, eff_stat_diff
	, eff_rating_diff
FROM
	`bracketology.training_new_features`
WHERE
	season BETWEEN 2014 AND 2017
