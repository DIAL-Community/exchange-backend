#!/bin/bash
set -e

exit_code="Weekly Sync Exits -> "

cd /product-evaluation-rubric                       || exit_code+=" 1"
git pull                                            || exit_code+=" 2"
echo $exit_code

cd /t4d                                             || exit_code+=" 3"
echo $exit_code

rake maturity_sync:update_license_data              || exit_code+=" 7"
rake maturity_sync:update_statistics_data           || exit_code+=" 8"
rake maturity_sync:update_code_review_indicators    || exit_code+=" 9"
rake maturity_sync:update_products_languages        || exit_code+=" 10"
rake maturity_sync:update_api_docs_indicators       || exit_code+=" 11"

rake sync:fetch_website_data                        || exit_code+=" 12"

rake data_processors:process_product_spreadsheet    || exit_code+=" 14"
rake data_processors:process_dataset_spreadsheet    || exit_code+=" 15"
rake data_processors:process_exported_json_files    || exit_code+=" 16"

rake opportunity_sync:sync_leverist                 || exit_code+=" 18"
rake opportunity_sync:sync_ungm                     || exit_code+=" 19"
rake opportunity_task:close_opportunities           || exit_code+=" 20"

rake resource_sync:sync_dial_resources              || exit_code+=" 24"
rake resource_sync:sync_dpi_resources               || exit_code+=" 25"

echo $exit_code