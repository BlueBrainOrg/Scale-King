extends CharacterBody2D

@export var gravity:= 0.75
@export var terminal_velocity:= 1000.0

@export var max_jump_force:= 500
@export var seconds_to_max_force:= 0.5

@onready var mountain = get_parent()
@onready var progress_bar = $ProgressBar
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_left : RayCast2D = $RayCast2DLeft
@onready var ray_right : RayCast2D = $RayCast2DRight
@onready var collision_shape = $CollisionShape2D

var was_on_wall = false

var hanging:= false

var hanging_time := 0.0
var jump_angle:= Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play()

func _process(delta):
	animated_sprite_2d.rotation = jump_angle.angle() + deg_to_rad(90)


func _physics_process(delta):
	if hanging:
		self.velocity = Vector2.ZERO
	else:
		if not is_on_floor():
			if ray_left.is_colliding() or ray_right.is_colliding():
				self.velocity.x *= -0.75
		_apply_gravity(delta)
		
	self.move_and_slide()



func _apply_gravity(delta):
	self.velocity.y += terminal_velocity * gravity * delta
	self.velocity.y = min(terminal_velocity, self.velocity.y)

func jump():
	var jump_force = max_jump_force * min(hanging_time / seconds_to_max_force, 1)
	self.hanging = false
	self.velocity = jump_angle * jump_force
	self.hanging_time = 0
	var tween = create_tween()
	animated_sprite_2d.animation = "jumping"
	tween.tween_property(progress_bar, "value", 0, 0.1)
