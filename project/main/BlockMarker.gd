extends Sprite

export(NodePath) var world_path
onready var world: TileMap = get_node(world_path)

func _process(delta):
	var blockindex = world.world_to_map(world.to_local(get_global_mouse_position()))
	
	if world.get_cellv(blockindex) == -1:
		visible = false
	else:
		visible = true
		global_position = world.to_global(world.map_to_world(blockindex) + world.cell_size/2)

	# todo: put this in a different place
	if Input.is_action_pressed("mine"):
		world.set_cellv(blockindex, -1)
