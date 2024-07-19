extends Node

@export var lose_scene : PackedScene
@export var win_scene : PackedScene

@export var game_scene : PackedScene

func main_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
