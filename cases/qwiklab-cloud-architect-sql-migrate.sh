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




# access compute engine > VM Instances > Blog VM > SSH


## dump mySQL data
mysqldump --database wordpress \
	-h localhost \
	-u blogadmin \
	-p \
	--hex-blob \
	--skip-triggers \
	--single-transaction \
	--default-character-set=utf8mb4 \
	> wordpress.sql


## upload to cloud storage
export PROJECT="$(gcloud config get-value project)"
gsutil mb "gs://${PROJECT}"
gsutil cp ~/wordpress.sql "gs://${PROJECT}"




# use cloud SQL web interface to create the instance accordingly




# Head back to Compute Engine > VM Instances > Blog VM > SSH terminal
/etc/init.d/mysql stop
/etc/init.d/mysql status
vi wp-config.php


## replace localhost from "define('DB_HOST', 'localhost')" with CloudSQL public
## IP into "define('DB_HOST', 'XXX.XXX.XXX.XXX')". Save it once done.


## You will notice the blog will be back again.
