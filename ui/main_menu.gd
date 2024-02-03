extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(GlobalState.level_scene)
	
func _on_credits_pressed() -> void:
	get_tree().change_scene_to_packed(GlobalState.credits_scene)

func _on_exit_pressed() -> void:
	get_tree().quit()
