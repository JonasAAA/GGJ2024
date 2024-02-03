extends Node

var main_menu_scene: PackedScene = preload("res://ui/main_menu.tscn")
var level_scene: PackedScene = preload("res://level.tscn")
var credits_scene: PackedScene = preload("res://ui/credits.tscn")

func _ready() -> void:
	Wwise.load_bank("Init")
	Wwise.load_bank("Demo_Soundbank")
	
	# Demo
	Wwise.register_listener(self)
	Wwise.register_game_obj(self, "Demo Game Object")
