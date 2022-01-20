import json
import os
project = json.load(open("project.json"))

for target in project["targets"]:
    if target["name"] != 'Visuals': continue
    for costume in target["costumes"]:
        try:
            os.rename(f"minercat2_assets/{costume['md5ext']}", f"minercat2_assets_renamed/{costume['name']}.{costume['dataFormat']}")
        except FileNotFoundError:
            print(f"NOT FOUND: {costume['name']}")