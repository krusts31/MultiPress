import csv
import subprocess
import json

# Replace with your CSV file name
csv_file = "merged.csv"

# Replace with the names of the columns you want to use
columns_to_print = ["name_lv", "description_lv", "small_text_lv", "Price", "picture", "meta_description_lv"]

site = "lv.bio113-dev.com"

with open(csv_file, mode='r', encoding='utf-8') as file:
    csv_reader = csv.DictReader(file)
    for row in csv_reader:
        values = [row[column] for column in columns_to_print]

        # For images and meta_data, create an array of objects
        #images = json.dumps([{"src": values[4]}])
        meta_data = json.dumps([{"key": "description", "value": values[5]}])

        command = [
            "wp", "--url={}".format(site), "wc", "product", "create",
            "--name={}".format(values[0]),
            "--type=simple",
            "--description={}".format(values[1]),
            "--short_description={}".format(values[2]),
            "--regular_price={}".format(values[3]),
            #"--images={}".format(images),
            "--meta_data={}".format(meta_data),
            "--user={}".format('admin')
        ]

        # Execute the subprocess command
        subprocess.run(command, check=True)
