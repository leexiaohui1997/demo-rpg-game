extends CharacterBody2D
class_name Player

@export_group("Stats")
@export var max_hp := 10.0
@export var max_mp := 10.0
@export var move_speed := 60.0
@export var damage := 5.0
@export var crit_chance := 0.0
@export var crit_damage := 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FSM = $FSM
@onready var hp_bar: StateBar = $HpBar
@onready var mp_bar: StateBar = $MpBar

var current_hp := 0.0
var current_mp := 0.0

var animation_direction := "down"
var _direction := Vector2.ZERO
var direction: Vector2:
	get():
		return _direction
	set(value):
		_direction = value
		if _direction.y < 0:
			animation_direction = "up"
		elif _direction.y > 0:
			animation_direction = "down"
		elif _direction.x < 0:
			animation_direction = "left"
		elif _direction.x > 0:
			animation_direction = "right"

func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if fsm.current_state:
		fsm.current_state.process_state(delta)

func play_animation(animation_name: String) -> void:
	animated_sprite_2d.play("%s_%s" % [animation_name, animation_direction])

func is_moving() -> bool:
	return direction != Vector2.ZERO

func setup() -> void:
	hp_bar.current_state = max_hp
	mp_bar.current_state = max_mp

func _on_hp_bar_on_state_changed(current: float) -> void:
	EventBus.on_player_hp_changed.emit(current, max_hp)

func _on_mp_bar_on_state_changed(current: float) -> void:
	EventBus.on_player_mp_changed.emit(current, max_mp)
