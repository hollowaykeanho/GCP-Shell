#!/bin/bash
#
# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

REGION="us-central1"

AI_VERSION_NAME="v1"
AI_MODEL_NAME="model-name"
AI_FRAMEWORK="TENSORFLOW"
AI_PYTHON_VERSION="3.7"
AI_ORIGIN="${MODEL_BUCKET}/saved_complete_model/complete_model"
RUNTIME_VERSION="2.3"




# create the ai model with version name
gcloud ai-platform versions create "$AI_VERSION_NAME" \
	--region "$REGION" \
	--model "$AI_MODEL_NAME" \
	--framework "$AI_FRAMEWORK" \
	--runtime-version "$RUNTIME_VERSION" \
	--origin "$AI_ORIGIN" \
	--staging-bucket "$MODEL_BUCKET" \
	--python-version "$AI_PYTHON_VERSION"
