import subprocess
import json

# Replace with the names of the columns you want to use
categories = ['']

site = "lv.bio113-dev.com"

images = json.dumps([{"src": "https://" +  "bio113.com/th/340x300_6/" +  values[4].strip('/')}])
meta_data = json.dumps([{"key": "description", "value": values[5]}])

command = [
    "wp", "--url={}".format(site), "wc", "category", "create",
    "--path={}".format("/var/www/html"),
    "--name={}".format(values[0]),
    "--images={}".format(images),
    "--user={}".format('admin')
]

try:
    subprocess.run(command, check=True)
except Exception as e:
    print("ERROR:", e)
