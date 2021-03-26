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

API_KEY="your-api-key" # create one via API & Service > Credentials

DOC_TYPE="PLAIN_TEXT" # or HTML
DOC_CONTENT="TO PUBLIC GOOD the dispatches For Obama, the mustard is from Dijon"
DOC_ENCODING="UTF8"




# call translate API
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://language.googleapis.com/v1/documents:analyzeEntities?key=${API_KEY}" << EOF
{
  "document":{
    "type":"$DOC_TYPE",
    "content":"$DOC_CONTENT"
  },
  "encodingType":"$DOC_ENCODING"
}
EOF
