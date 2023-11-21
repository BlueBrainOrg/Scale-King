@tool
extends Marker2D

signal climber_entered
signal climber_left
@onready var area_2d: Area2D = $Area2D

@export var max_dificulty := 5  ## if parent's difficulty is higher than this value, this anchor point will not spawn

var is_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.update()
	var parent = self.get_parent()
	if "difficulty_changed" in parent:
		parent.difficulty_changed.connect(update_wrapper)
	self.global_rotation = 0
	is_ready = true


func _on_area_2d_body_entered(body):
	if body.is_in_group("climbers"):
		climber_entered.emit(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("climbers"):
		climber_left.emit(body)

func update_wrapper(_x):
	self.update()

func update():
	var parent = get_parent()
	if "difficulty" in parent and parent._difficulty > self.max_dificulty:
		self.disable()
	else:
		self.enable()

func disable():
	self.hide()
	if not is_ready:
		await self.ready
	self.area_2d.monitoring = false
	self.area_2d.monitorable = false

func enable():
	self.show()
	if not is_ready:
		await self.ready
	self.area_2d.monitoring = true
	self.area_2d.monitorable = true
