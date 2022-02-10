extends KinematicBody2D

var velocity = Vector2(0, 0)
enum {LEFT, RIGHT}
var direction = RIGHT

const acc = 2 * 30.0
const friction = pow(0.8, 30.0)
const jump_force = 18

signal snap_camera

func _ready():
	emit_signal("snap_camera")
	
func _physics_process(dt):
	if Game.paused:
		return
		
	if Input.is_action_pressed("left"):
		velocity.x -= acc * dt
		direction = LEFT
	if Input.is_action_pressed("right"):
		velocity.x += acc * dt
		direction = RIGHT
	velocity.x *= pow(friction, dt)
	
	velocity.y += 30 * dt
	if velocity.y > 63:
		velocity.y = 63
	
	velocity = move_and_slide(velocity * 30, Vector2(0, -1)) / 30.0
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	if not is_on_floor():
		set_animation("fall")
	else:
		if abs(velocity.x) > 0.5:
			set_animation("run")
		else:
			set_animation("idle")

func set_animation(anim):
	$AnimatedSprite.animation = anim + ("left" if direction == LEFT else "right")
