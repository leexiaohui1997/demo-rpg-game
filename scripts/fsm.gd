extends Node
class_name FSM

signal on_state_changed(state_name: String)

@export var initial_state: NodePath

var current_state: State

func _ready() -> void:
	await owner.ready
	for state: State in get_children():
		state.fsm = self
	current_state = get_node(initial_state)
	current_state.enter_state()

func change_state(state_name: String) -> void:
	if not has_node(state_name):
		return
	if current_state:
		current_state.exit_state()
	current_state = get_node(state_name)
	current_state.enter_state()
	on_state_changed.emit(state_name)
