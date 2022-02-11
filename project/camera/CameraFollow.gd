extends Camera2D

export(NodePath) var follow_path
export(Vector2) var follow_offset = Vector2(0,0)

var follow

func _ready():
	follow = get_node(follow_path)
	follow.connect("snap_camera", self, "_on_follow_snap_camera")
	
	limit_left = 0
	limit_right = Game.block_size * Game.world_size
	limit_top = -180

func _on_follow_snap_camera():
	position = follow.position + follow_offset

func _process(delta):
	position += (follow.position + follow_offset - position) / 2
