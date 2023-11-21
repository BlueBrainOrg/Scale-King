extends Node

@onready var climber = get_parent()
@export var rotation_speed := 2.0
@export var walk_speed := 100.0

@onready var progress_bar = $"../ProgressBar"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if climber.is_on_floor():
		_walk(delta)
		_ground_jump(delta)
	else:
		_direction_logic(delta)
		_hang_jump_logic(delta)

func _walk(delta):
	var h_input = Input.get_axis("ui_left", "ui_right")
	climber.animated_sprite_2d.animation = "standing"
	climber.jump_angle = Vector2.UP
	climber.velocity.x = h_input * walk_speed
	climber.hanging_time = climber.seconds_to_max_force / 2

func _ground_jump(delta):
	if Input.is_action_just_pressed("ui_accept"):
		climber.jump()

func _direction_logic(delta):
	var h_input = Input.get_axis("ui_left", "ui_right")
	if abs(h_input) > 0.001:
		climber.jump_angle = climber.jump_angle.rotated(deg_to_rad(h_input))


func _hang_jump_logic(delta):
	if Input.is_action_just_pressed("ui_accept"):
		climber.hanging = climber.mountain.hang(climber)
		climber.animated_sprite_2d.animation = "hanging"

	if Input.is_action_just_released("ui_accept"):
		climber.animated_sprite_2d.animation = "jumping"
		if climber.hanging:
			climber.jump()

	if Input.is_action_pressed("ui_accept") and climber.hanging:
		climber.hanging_time += delta
		progress_bar.value = climber.hanging_time / climber.seconds_to_max_force * 100
		if climber.hanging_time > climber.seconds_to_max_force:
			climber.jump()
