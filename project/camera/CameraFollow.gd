extends Camera2D

export(NodePath) var follow_path

var follow

func _ready():
	follow = get_node(follow_path)
	follow.connect("snap_camera", self, "_on_follow_snap_camera")

func _on_follow_snap_camera():
	position = follow.position

func _process(delta):
	position += (follow.position - position) / 2
	constrain_position()

func constrain_position():
	if position.y < 0:
		position.y = 0
