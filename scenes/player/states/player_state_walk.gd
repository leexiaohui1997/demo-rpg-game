extends PlayerState
class_name PlayerStateWalk

func enter_state() -> void:
	player.play_animation("walk")
	player.on_direction_change.connect(_on_player_direction_change)

func process_state(_delta: float) -> void:
	if not player.is_moving():
		fsm.change_state("Idle")
		return

	player.velocity = player.direction * player.move_speed
	player.move_and_slide()

func exit_state() -> void:
	player.on_direction_change.disconnect(_on_player_direction_change)

func _on_player_direction_change() -> void:
	player.play_animation("walk")
