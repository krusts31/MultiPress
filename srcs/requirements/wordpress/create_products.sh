#!/bin/sh

# Set your CSV file name
csv_file="merged.csv"

# Set the WooCommerce site URL
site="lv.bio113-dev.com"

# Define an array of column names to be used
columns=("name_lv" "description_lv" "small_text_lv" "Price" "picture" "meta_description_lv")

# Read the CSV file line by line
while IFS=, read -r "${columns[@]}"
do
    # Convert image and meta_description to JSON format
    # Uncomment and modify the images line if needed
    # images=$(printf '[{"src":"%s"}]' "$picture")
    meta_data=$(printf '[{"key":"description","value":"%s"}]' "$meta_description_lv")

    # Construct the command
    command=(
        wp --url="$site" wc product create
        --name="$name_lv"
        --type=simple
        --description="$description_lv"
        --short_description="$small_text_lv"
        --regular_price="$Price"
        # --images="$images" # Uncomment if you want to include images
        --meta_data="$meta_data"
        --user=admin
    )

    # Execute the command
    "${command[@]}"
done < <(tail -n +2 "$csv_file") # Skip the header row of the CSV file
