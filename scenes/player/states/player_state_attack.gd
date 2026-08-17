extends PlayerState
class_name PlayerStateAttack

const DIRECTION_ANGLE: Dictionary[String, float] = {
	"up": 0,
	"right": 90,
	"down": 180,
	"left": 270
}

func enter_state() -> void:
	player.play_animation("attack")
	player.animated_sprite_2d.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)
	update_weapon_position()
	player.on_direction_change.connect(_on_player_direction_change)
	player.weapon_attack_area.monitoring = true
	player.weapon.visible = true

func exit_state() -> void:
	player.weapon.visible = false
	player.weapon_attack_area.monitoring = false
	player.on_direction_change.disconnect(_on_player_direction_change)

func update_weapon_position() -> void:
	var direction := player.animation_direction
	var mark_pos := player.attack_pos.find_child(direction.capitalize()) as Marker2D
	player.weapon.position = mark_pos.position
	player.weapon.rotation_degrees = DIRECTION_ANGLE.get(direction)
	player.weapon_sprite_2d.flip_h = direction == "left"

func _on_animation_finished() -> void:
	fsm.change_state("Idle")

func _on_player_direction_change() -> void:
	player.play_animation("attack")
	update_weapon_position()
