extends Node2D

export(NodePath) var world_path
onready var world: TileMap = get_node(world_path)
export(NodePath) var touchscreen_controls_path
onready var touchscreen_controls = get_node(touchscreen_controls_path)

# only the most recent is used for mining
# to avoid mining multiple blocks
var touch_index = 0

var cursor_canvas_position = Vector2(0,0)
var is_mining = false
var is_hovering = false

func _process(delta):
	# TODO XXX BUG: WHEN THE CAT IS MOVING FAST
	# THE CROSSHAIR IS IN THE WRONG POSITION
	var global_cursor_position = get_canvas_transform().affine_inverse().xform(cursor_canvas_position)
	var blockindex = world.world_to_map(world.to_local(global_cursor_position))
	
	$Crosshair.global_position = global_cursor_position
	$Crosshair.visible = is_hovering
	
	if !is_hovering or world.get_cellv(blockindex) == -1:
		$BlockMarker.visible = false
	else:
		$BlockMarker.visible = true
		$BlockMarker.global_position = world.to_global(world.map_to_world(blockindex) + world.cell_size/2)

	if is_mining:
		world.set_cellv(blockindex, -1)

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		var touch_canvas_position = event.position
		if is_on_button(touch_canvas_position):
			return
		touch_index = event.index
		cursor_canvas_position = touch_canvas_position
		is_mining = true
		is_hovering = true
	if event is InputEventScreenTouch and not event.pressed and event.index == touch_index:
		touch_index = -1
		is_mining = false
		is_hovering = false
	if event is InputEventScreenDrag and event.index == touch_index:
		var touch_position = event.position
		if is_on_button(touch_position):
			touch_index = -1
			is_mining = false
			is_hovering = false
			return
		cursor_canvas_position = event.position
	if event is InputEventMouse:
		# https://github.com/godotengine/godot/blob/404364d4b4eb3949ea85f628fd1cb85fdaa59399/scene/main/canvas_item.cpp#L793
		cursor_canvas_position = event.position
		is_hovering = true
	if event is InputEventMouseButton and event.button_index == 1:
		is_mining = event.pressed
		
func is_on_button(touch_canvas_position):
	# I SPENT SO MUCH EFFORT ON THIS
	# COORDINATE SYSTEMS KSJDF:IOJSG:OIJ
	var canvas_position = touch_canvas_position
	# touchscreen_controls is CanvasLayer
#	var canvaslayer_position = touchscreen_controls.transform.affine_inverse().xform(canvas_position)
#	print("Canvaslayer position ", canvaslayer_position)
	for touchscreen_button in touchscreen_controls.get_children():
		var button_topleft_canvasposition = touchscreen_button.position
		var button_center_canvasposition = button_topleft_canvasposition + touchscreen_button.normal.get_size() * 0.5 * touchscreen_button.scale
		# assume it's a rectangle shape
		assert(touchscreen_button.shape is RectangleShape2D)

		var button_rect = Rect2(button_center_canvasposition - touchscreen_button.shape.extents/2, touchscreen_button.shape.extents)
		if button_rect.has_point(touch_canvas_position):
			return true
#		touchscreen_button.shape.collide(Transform2D(0, button_center_canvasposition), )
#		print(button_center_canvasposition)
		#var pos = touchscreen_button.normal.get_size() * 0.5 if touchscreen_button.shape_centered else Vector2(0,0)
	return false

#		var unit_rect = RectangleShape2D.new()
#		unit_rect.extents = Vector2(1, 1)
		
		#if touchscreen_button.shape.collide(Transform2D().translated(pos), unit_rect, Transform2D(0, touch_position + Vector2(0.5, 0.5))):
			
		#	return true
#		else:
#			print("Didn't collide with ", touchscreen_button)
#		return false
