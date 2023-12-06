#!/bin/bash
set -e

exit_code="Exits -> "

cd /product-evaluation-rubric                       || exit_code+=" 1"
git pull                                            || exit_code+=" 2"
echo $exit_code

cd /t4d                                             || exit_code+=" 3"
echo $exit_code

rake sync:public_goods                              || exit_code+=" 4"
rake sync:digi_square_digital_good                  || exit_code+=" 5"
rake sync:osc_digital_good_local                    || exit_code+=" 6"
rake maturity_sync:update_license_data              || exit_code+=" 7"
rake maturity_sync:update_statistics_data           || exit_code+=" 8"
rake maturity_sync:update_code_review_indicators    || exit_code+=" 9"
rake maturity_sync:update_products_languages        || exit_code+=" 10"
rake maturity_sync:update_api_docs_indicators       || exit_code+=" 11"
rake sync:fetch_website_data                        || exit_code+=" 12"
rake endorsers:sync_form_response                   || exit_code+=" 13"
rake data_processors:process_product_spreadsheet    || exit_code+=" 14"
rake data_processors:process_dataset_spreadsheet    || exit_code+=" 15"
rake data_processors:process_exported_json_files    || exit_code+=" 16"
rake markdown_sync:use_case_definition              || exit_code+=" 17"
rake opportunities_sync:sync_leverist               || exit_code+=" 18"
rake opportunity:close_opportunities                || exit_code+=" 19"
rake govstack:sync_govstack_procurements            || exit_code+=" 20"

echo $exit_code
