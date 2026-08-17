extends CharacterBody2D
class_name Player

signal on_direction_change

@export_group("Stats")
@export var max_hp := 10.0
@export var max_mp := 10.0
@export var move_speed := 60.0
@export var damage := 5.0
@export var crit_chance := 0.0
@export var crit_damage := 0.0

@export_group("Exp")
@export var exp_base := 100
@export var exp_multiplier := 2.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FSM = $FSM
@onready var hp_bar: StateBar = $HpBar
@onready var mp_bar: StateBar = $MpBar
@onready var weapon: Node2D = $Weapon
@onready var weapon_attack_area: Area2D = $Weapon/WeaponAttackArea
@onready var weapon_sprite_2d: Sprite2D = $Weapon/WeaponSprite2D
@onready var attack_pos: Node2D = $AttackPos

var next_level_exp: float
var current_exp: float
var current_level := 1
var current_points := 0

var current_hp: float
var current_mp: float

var animation_direction := "down"
var _direction := Vector2.ZERO
var direction: Vector2:
	get():
		return _direction
	set(value):
		_direction = value
		var last_direction = animation_direction
		if _direction.y < 0:
			animation_direction = "up"
		elif _direction.y > 0:
			animation_direction = "down"
		elif _direction.x < 0:
			animation_direction = "left"
		elif _direction.x > 0:
			animation_direction = "right"
		if animation_direction != last_direction:
			on_direction_change.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and fsm.current_state.name != "Attack":
		fsm.change_state("Attack")

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if fsm.current_state:
		fsm.current_state.process_state(delta)

func add_exp(value: float) -> int:
	var old_level = current_level
	current_exp += value
	while current_exp >= next_level_exp:
		current_exp -= next_level_exp
		current_level += 1
		current_points += 4
		next_level_exp *= exp_multiplier
		EventBus.on_player_stats_changed.emit()
	EventBus.on_player_new_level.emit(current_exp, next_level_exp)
	return current_level - old_level

func play_animation(animation_name: String) -> void:
	animated_sprite_2d.play("%s_%s" % [animation_name, animation_direction])

func is_moving() -> bool:
	return direction != Vector2.ZERO

func setup() -> void:
	hp_bar.current_state = max_hp
	mp_bar.current_state = max_mp
	next_level_exp = exp_base

func _on_hp_bar_on_state_changed(current: float) -> void:
	EventBus.on_player_hp_changed.emit(current, max_hp)

func _on_mp_bar_on_state_changed(current: float) -> void:
	EventBus.on_player_mp_changed.emit(current, max_mp)
