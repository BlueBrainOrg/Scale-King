extends Node2D

@onready var climber = $Climber

var current_anchor_point

var anchored_climbers := {}

func _ready():
	for anchor in get_tree().get_nodes_in_group("anchor_points"):
		anchor.climber_entered.connect(climber_entered_anchor.bind(anchor))
		anchor.climber_left.connect(climber_left_anchor.bind(anchor))

func climber_entered_anchor(climber, anchor):
	anchored_climbers[climber.get_instance_id()] = anchor
	
func climber_left_anchor(climber, anchor):
	var climber_id = climber.get_instance_id()
	if climber_id in anchored_climbers:
		anchored_climbers.erase(climber_id)

func can_hang(body):
	return body.get_instance_id() in anchored_climbers

func hang(climber):
	var climber_id = climber.get_instance_id()
	if climber_id in anchored_climbers:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(climber, "global_position", anchored_climbers[climber_id].global_position, 0.06)
#		climber.global_position = anchored_climbers[climber_id].global_position
		return true
	return false
