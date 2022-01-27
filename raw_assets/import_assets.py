import json
import shutil
project = json.load(open("project.json"))

for target in project["targets"]:
    if target["name"] != 'Visuals': continue
    for costume in target["costumes"]:
        try:
            shutil.copy2(f"minercat2_assets/{costume['md5ext']}", f"minercat2_assets_renamed/{costume['name']}.{costume['dataFormat']}")
        except FileNotFoundError:
            print(f"NOT FOUND: {costume['name']}")