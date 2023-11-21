extends CanvasLayer


@export_node_path("CharacterBody2D") var climber_path
@onready var climber = get_node(climber_path)

@onready var max_height_value_label := %MaxHeightValueLabel
var max_height: int = 0 : set = set_max_height

@onready var timer := %Timer
var time := 0.0

func _physics_process(delta):
	var climber_height = -climber.global_position.y
	if climber_height > max_height:
		max_height = climber_height

func _process(delta):
	time += delta
	
	var minutes = str(int(time / 60))
	var seconds = str(int(fmod(time, 60.0)))
	while minutes.length() < 2:
		minutes = "0" + minutes
	while seconds.length() < 2:
		seconds = "0" + seconds
	timer.text = minutes + ":" + seconds


func set_max_height(value):
	max_height = value
	max_height_value_label.text = str(int(value))
