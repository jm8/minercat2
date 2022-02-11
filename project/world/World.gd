extends TileMap

var worldgen
var rng: RandomNumberGenerator

func _ready():
	var worldgen_file = File.new()
	worldgen_file.open("res://world/worldgen.json", File.READ)
	var worldgen_json = JSON.parse(worldgen_file.get_as_text())
	worldgen_file.close()
	worldgen = worldgen_json.result
	
	rng = RandomNumberGenerator.new()
	
	for layer in range(25):
		generate_layer(layer)

func is_in_range(x, json_range):
	return (
		((not "from" in json_range) or x >= json_range["from"])	 and
		((not "until" in json_range) or x < json_range["until"])
	)

func generate_layer(layer):
	var i = 0
	while not is_in_range(layer, worldgen["levels"][i]["range"]):
		i += 1
		
	var level = worldgen["levels"][i]
	for x in range(Game.world_size):
		for try in level["tries"]:
			if not "rarity" in try or rng.randi_range(1, try["rarity"]) == 1:
				if "block" in try:
					place_block(layer, x, try["block"])
				elif "spawnlayer" in try:
					if x == Game.world_size/2 - 1 or x == Game.world_size/2:
						place_block(layer, x, try["spawnlayer"]["center"])
					else:
						place_block(layer, x, try["spawnlayer"]["normal"])
				break

func place_block(layer, x, block_name):
	var tile_set_id
	if block_name == "air":
		tile_set_id = -1
	else:
		tile_set_id = tile_set.find_tile_by_name(block_name)
		assert(tile_set_id != -1, "couldn't find block %s" % block_name)
	set_cell(x, layer, tile_set.find_tile_by_name(block_name))
