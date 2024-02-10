class_name GlobalStateType extends Node

@export_range(0, 10000) var music_fade_duration_millisec: int = 1000
@export var music_transition_interpolation: AkUtils.AkCurveInterpolation = AkUtils.AK_CURVE_LINEAR
var main_menu_scene: PackedScene = preload("res://ui/main_menu.tscn")
var level_scene: PackedScene = preload("res://level.tscn")
var credits_scene: PackedScene = preload("res://ui/credits.tscn")
var is_menu_playing: bool
var playing_music_id: int

func _ready() -> void:
	Wwise.load_bank("Init")
	Wwise.load_bank("ClownSound")
	
	Wwise.register_listener(self)
	Wwise.register_game_obj(self, "GlobalState")
	playing_music_id = Wwise.post_event_id(AK.EVENTS.MUSICMENU, self)
	is_menu_playing = true

func play_menu_music() -> void:
	if is_menu_playing:
		return
	Wwise.stop_event(playing_music_id, music_fade_duration_millisec, music_transition_interpolation)
	playing_music_id = Wwise.post_event_id(AK.EVENTS.MUSICMENU, self)
	is_menu_playing = true

func play_gameplay_music() -> void:
	if not is_menu_playing:
		return
	Wwise.stop_event(playing_music_id, music_fade_duration_millisec, music_transition_interpolation)
	playing_music_id = Wwise.post_event_id(AK.EVENTS.MUSICGAMEPLAY, self)
	is_menu_playing = false
