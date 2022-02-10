extends Camera2D

export(NodePath) var follow_path

var follow

func _ready():
	follow = get_node(follow_path)

func _process(delta):
	position = follow.position
	if position.y > 0:
		position.y = 0
	
