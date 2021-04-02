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




/* using seed-only ML model to predict. In actual case: the match loss. */
SELECT
	model.label AS predicted_label
	, model.prob AS confidence
	, predictions.label AS correct_label
	, game_date
	, round
	, seed
	, school_ncaa
	, points
	, opponent_seed
	, opponent_school_ncaa
	, opponent_points
FROM
	`bracketology.predictions` AS predictions
	, UNNEST(predicted_label_probs) AS model
WHERE
	model.prob > .8
	AND predicted_label <> predictions.label
