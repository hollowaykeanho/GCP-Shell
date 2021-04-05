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
ROLE_PERMISSIONS="storage.buckets.get,storage.buckets.list"
ROLE_STAGE="ALPHA"




# update a role
gcloud iam roles update "$ROLE" \
	--project "$PROJECT" \
	--add-permissions "$ROLES_PERMISSIONS"




# update from file
## obtain a copy of the file using iam roles describe | etag from describe
### See iam-roles-describe.sh for more info.
ROLE_ETAG="BwVxLi4wTvk="


cat << EOF | gcloud iam roles update "$ROLE" --project "$PROJECT" --file -
description: "$ROLE_DESCRIPTION"
etag: $ROLE_ETAG
includedPermissions:
- compute.instances.get
- compute.instances.list
- storage.buckets.get
- storage.buckets.list
name: projects/${PROJECT}/roles/${ROLE}
stage: "$ROLE_STAGE"
title: "$ROLE_TITLE"
EOF
## OR: gcloud iam roles update "$ROLE" --project "$PROJECT" --file role.yaml
