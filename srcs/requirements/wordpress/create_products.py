import csv
import subprocess
import json

# Replace with your CSV file name
csv_file = "/tmp/lv.csv"

# Replace with the names of the columns you want to use
columns_to_print = ["name_lv", "description_lv", "small_text_lv", "price", "picture", "meta_description_lv"]

site = "lv.bio113-dev.com"

with open(csv_file, mode='r', encoding='utf-8') as file:
    csv_reader = csv.DictReader(file)
    for row in csv_reader:
        # Convert the row to a dictionary using column names
        values = {column: row[column] for column in columns_to_print}

        # For images and meta_data, create an array of objects
        images = json.dumps([{"src": "https://" +  "bio113.com/th/340x300_6/" +  values["picture"].strip('/')}])
        #meta_data = json.dumps([{"key": "description", "value": values["meta_description_lv"]}])

        command = [
            "wp", "--url={}".format(site), "wc", "product", "create",
            "--path={}".format("/var/www/wordpress"),
            "--name={}".format(values["name_lv"]),
            "--type=simple",
            "--description={}".format(values["description_lv"]),
            "--short_description={}".format(values["small_text_lv"]),
            "--regular_price={}".format(values["price"]),
            "--images={}".format(images),
            #"--meta_data={}".format(meta_data),
            "--user={}".format('admin')
        ]

        # Execute the subprocess command
        try:
            subprocess.run(command, check=True)
        except Exception as e:
            command = [
                "wp", "--url={}".format(site), "wc", "product", "create",
                "--path={}".format("/var/www/wordpress"),
                "--name={}".format(values["name_lv"]),
                "--type=simple",
                "--description={}".format(values["description_lv"]),
                "--short_description={}".format(values["small_text_lv"]),
                "--regular_price={}".format(values["price"]),
                #"--meta_data={}".format(meta_data),
                "--user={}".format('admin')
            ]
            print("ERROR:", e)

