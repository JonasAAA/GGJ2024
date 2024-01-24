extends Node

func _ready() -> void:
	Wwise.load_bank("Init")
	Wwise.load_bank("Demo_Soundbank")
	
	# Demo
	Wwise.register_listener(self)
	Wwise.register_game_obj(self, "Demo Game Object")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		Wwise.post_event_id(AK.EVENTS.DEMO_EVENT, self)
