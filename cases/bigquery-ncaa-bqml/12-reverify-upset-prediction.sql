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




/* using ML model to predict */
SELECT
	CONCAT(school_ncaa
		, " was predicted to "
		, IF(predicted_label="loss","lose","win")
		, " "
		, CAST(ROUND(p.prob, 2)*100 AS STRING)
		, "% but "
		, IF(n.label="loss", "lost", "won")
	) AS narrative
	, predicted_label
	, n.label
	, ROUND(p.prob, 2) AS probability
	, season
	, seed
	, school_ncaa
	, efficiency_rank
	, opponent_seed
	, opponent_school_ncaa
	, opp_pace_rank
FROM
	`bracketology.ncaa_2018_predictions` AS n
	, UNNEST(predicted_label_probs) AS p
WHERE
	predicted_label <> n.label
	AND p.prob > .75
ORDER BY
	prob DESC
