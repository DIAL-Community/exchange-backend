#!/bin/bash
set -e

exit_code="Monthly Sync Exits -> "

cd /t4d                                             || exit_code+=" 3"
echo $exit_code


rake endorsers:sync_form_response                   || exit_code+=" 13"

rake govstack:sync_govstack_procurements            || exit_code+=" 21"

rake product_sync:digital_square_implementation     || exit_code+=" 22"

rake gdpir_sync:sync_products\[../www.dpi.global\]  || exit_code+=" 23"

echo $exit_code