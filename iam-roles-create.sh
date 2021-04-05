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

PROJECT="$(gcloud config get-value project)"
ROLE="editor"
ROLE_TITLE="Role Editor"
ROLE_DESCRIPTION="custom role description"
ROLE_PERMISSIONS="compute.instances.get,compute.instances.list"
ROLE_STAGE="ALPHA"




# create a role
gcloud iam roles create "$ROLE" \
	--project "$PROJECT" \
	--title "$ROLE_TITLE" \
	--description "$ROLE_DESCRIPTION" \
	--permissions "$ROLE_PERMISSIONS" \
	--stage "$ROLE_STAGE"




# creat from file
cat << EOF | gcloud iam roles create "$ROLE" --project "$PROJECT" --file -
title: "$ROLE_TITLE"
description: "$ROLE_DESCRIPTION"
stage: "$ROLE_STAGE"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
EOF
## OR: gcloud iam roles create "$ROLE" --project "$PROJECT" --file role.yaml
