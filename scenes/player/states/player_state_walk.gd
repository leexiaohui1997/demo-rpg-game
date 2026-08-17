extends PlayerState
class_name PlayerStateWalk

func enter_state() -> void:
	player.play_animation("walk")

func process_state(_delta: float) -> void:
	if not player.is_moving():
		fsm.change_state("Idle")
		return
	player.velocity = player.direction * player.move_speed
	player.move_and_slide()
