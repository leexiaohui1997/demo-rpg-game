extends PlayerState
class_name PlayerStateIdle

func enter_state() -> void:
	player.play_animation("idle")

func process_state(_delta: float) -> void:
	if player.is_moving():
		fsm.change_state("Walk")
