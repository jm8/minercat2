extends Sprite

func _process(delta):
	global_transform.origin = get_global_mouse_position()
