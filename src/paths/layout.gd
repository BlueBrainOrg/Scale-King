@tool
extends Node2D

signal difficulty_changed(value: int)

@export var difficulty := 1 : set = set_difficulty
@export var max_difficulty := 1 : set = set_max_difficulty

var parent

var _difficulty = null : get = get_difficulty

func get_difficulty():
	var parent = self.get_parent()
	if parent != null and "difficulty" in parent:
		return max(parent.difficulty, self.difficulty)
	return self.difficulty

func _ready():
	parent = self.get_parent()
	if "difficulty" in parent:
		self.difficulty = get_parent().difficulty
	if "difficulty_changed" in parent:
		parent.difficulty_changed.connect(set_difficulty)
	self.update()

func set_difficulty(value):
	difficulty = value
	difficulty_changed.emit(self._difficulty)
	self.update()

func set_max_difficulty(value):
	max_difficulty = value
	self.update()

func update():
	for child in get_children():
		if self._difficulty > self.max_difficulty:
			if "disable" in child:
				if is_instance_valid(child):
					child.disable()
		else:
			child.update()
