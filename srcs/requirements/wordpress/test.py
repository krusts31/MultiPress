import csv
import subprocess
import json

# Replace with your CSV file name
csv_file = "/tmp/merged.csv"

# Replace with the names of the columns you want to use
columns_to_print = ["name_lv", "description_lv", "small_text_lv", "Price", "picture", "meta_description_lv"]

site = "lv.bio113-dev.com"

with open(csv_file, mode='r', encoding='utf-8') as file:
    csv_reader = csv.DictReader(file)
    for row in csv_reader:
        values = [row[column] for column in columns_to_print]

        # For images and meta_data, create an array of objects
        #images = json.dumps([{"src": values[4]}])
        #"/wp-content/uploads/pictures/"
        images = json.dumps([{"src": "https://" +  "bio113.com/th/340x300_6/" +  values[4].strip('/')}])
        meta_data = json.dumps([{"key": "description", "value": values[5]}])

        command = [
            "wp", "--url={}".format(site), "wc", "product", "create",
            "--path={}".format("/var/www/html"),
            "--name={}".format(values[0]),
            "--type=simple",
            "--description={}".format(values[1]),
            "--short_description={}".format(values[2]),
            "--regular_price={}".format(values[3]),
            "--images={}".format(images),
            "--meta_data={}".format(meta_data),
            "--user={}".format('admin')
        ]

        # Execute the subprocess command

        try:
            subprocess.run(command, check=True)
        except Exception as e:
            print("ERROR:", e)
            command = [
                "wp", "--url={}".format(site), "wc", "product", "create",
                "--path={}".format("/var/www/html"),
                "--name={}".format(values[0]),
                "--type=simple",
                "--description={}".format(values[1]),
                "--short_description={}".format(values[2]),
                "--regular_price={}".format(values[3]),
                "--meta_data={}".format(meta_data),
                "--user={}".format('admin')
            ]
            subprocess.run(command, check=True)
