extends Node
class_name StateBar

signal on_state_changed(current: float)
signal on_consume_out

@export_enum("hp", "mp") var state_type = "hp"

var character: Node2D

var current_state: float:
	set(value):
		if character:
			character.set("current_%s" % [state_type], value)
			on_state_changed.emit(value)
			if value <= 0:
				on_consume_out.emit()
	get:
		return 0 if not character else character.get("current_%s" % [state_type])

var max_state: float:
	get:
		return 0 if not character else character.get("max_%s" % [state_type])

func _ready() -> void:
	character = owner

func consume(value: float) -> bool:
	if current_state < value:
		return false
	current_state -= value
	return true

func consume_force(value: float) -> bool:
	if current_state <= 0:
		return false
	current_state = max(0, current_state - value)
	return true
