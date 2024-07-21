extends Node

signal has_won
signal has_lost

var lose_scene : PackedScene = load("res://Scenes/menus/lose_menu.tscn")
var win_scene : PackedScene = load("res://Scenes/menus/win_menu.tscn")

var game_scene : PackedScene = load("res://main.tscn")

func _ready():
	has_won.connect(win)
	has_lost.connect(lose)
	
func win() -> void:
	get_tree().change_scene_to_packed(win_scene)
	
func lose() -> void:
	get_tree().change_scene_to_packed(lose_scene)
