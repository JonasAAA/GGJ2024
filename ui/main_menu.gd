extends Control

# Using this instead of global_state directly makes GDScript understand that GlobalState is of type GlobalStateType, not Node
var global_state: GlobalStateType = GlobalState

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(global_state.level_scene)
	
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(global_state.credits_scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
