extends Node

signal on_player_created
signal on_player_hp_changed(current: float, max: float)
signal on_player_mp_changed(current: float, max: float)
signal on_player_new_level(current: float, new_level: float)
signal on_player_stats_changed
