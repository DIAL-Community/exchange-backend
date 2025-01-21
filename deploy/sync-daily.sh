#!/bin/bash
set -e

exit_code="Daily Sync Exits -> "

cd /t4d                                             || exit_code+=" 3"
echo $exit_code

rake sync:public_goods                              || exit_code+=" 4"
rake sync:digi_square_digital_good                  || exit_code+=" 5"
rake sync:osc_digital_good_local                    || exit_code+=" 6"

rake markdown_sync:use_case_definition              || exit_code+=" 17"

echo $exit_code
