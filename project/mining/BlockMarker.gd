extends Sprite

export(NodePath) var world_path
onready var world: TileMap = get_node(world_path)

# only the most recent is used for mining
# to avoid mining multiple blocks
var touch_index = 0
var cursor_position = Vector2(0,0)
var is_mining = false
var is_hovering = false

func _process(delta):
	var blockindex = world.world_to_map(world.to_local(cursor_position))
	
	
	if !is_hovering or world.get_cellv(blockindex) == -1:
		visible = false
	else:
		visible = true
		global_position = world.to_global(world.map_to_world(blockindex) + world.cell_size/2)

	# todo: put this in a different place
	if is_mining:
		world.set_cellv(blockindex, -1)

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		touch_index = event.index
		cursor_position = get_canvas_transform().affine_inverse().xform(event.position)
		is_mining = true
		is_hovering = true
	if event is InputEventScreenTouch and not event.pressed and event.index == touch_index:
		touch_index = -1
		is_mining = false
		is_hovering = false
	if event is InputEventScreenDrag and event.index == touch_index:
		cursor_position = get_canvas_transform().affine_inverse().xform(event.position)
	if event is InputEventMouse:
		# https://github.com/godotengine/godot/blob/404364d4b4eb3949ea85f628fd1cb85fdaa59399/scene/main/canvas_item.cpp#L793
		cursor_position = get_canvas_transform().affine_inverse().xform(event.position)
		is_hovering = true
	if event is InputEventMouseButton and event.button_index == 1:
		is_mining = event.pressed
