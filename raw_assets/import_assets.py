import json
import os
import shutil
project = json.load(open("project.json"))

prefixes = [
    'letter',
    'armor',
    'backpack',
    'block',
    'crack',
    'letter',
    'pickaxe',
    'shop',
]

def get_prefix(name):
    for prefix in prefixes:
        if name.startswith(prefix):
            return prefix

    return 'other'
    

for target in project["targets"]:
    if "costumes" not in target: continue
    #if target["name"] != 'Visuals': continue
    if target["name"] != 'Visuals':
        folder = target["name"]
    else:
        folder = get_prefix(target["name"])
    for costume in target["costumes"]:
        try:
            os.makedirs(f'minercat2_assets_renamed/{folder}')
        except FileExistsError:
            pass
        try:
            shutil.copy2(f"minercat2_assets/{costume['md5ext']}", f"minercat2_assets_renamed/{folder}/{costume['name']}.{costume['dataFormat']}")
        except FileNotFoundError:
            fullpath = os.path.abspath(f"minercat2_assets/{costume['md5ext']}")
            print(f"NOT FOUND: {costume['name']}: {fullpath}")
