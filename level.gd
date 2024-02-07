extends Node2D

const max_clowns: int = 2
const miss_people_to_lose: int = 3
const person_template: PackedScene = preload("res://person.tscn")
const clown_template: PackedScene = preload("res://clown.tscn")
@onready var paths: Array[Path2D] = [$Path0, $Path1, $Path2, $Path3, $Path4, $Path5, $Path6]
@onready var level_ui: LevelUI = $UICanvas/ui_pos/LevelUI
@onready var game_over_ui: Control = $UICanvas/GameOver
var people: Array[Person] = []
var clowns: Array[Clown] = []
var clown_to_place: Clown = null

func _ready() -> void:
	Wwise.register_game_obj(self, "Level")
	GlobalState.play_gameplay_music()
	
	spawn_person()
	set_new_clown_to_place()
	level_ui.score = 0
	game_over_ui.hide()
	
func _on_tree_exited() -> void:
	GlobalState.play_menu_music()
	
func clown_entered(area: Area2D) -> void:
	var person: Person = area as Person
	if person == null:
		return
	Wwise.post_event_id(AK.EVENTS.CLOWNAREAENTERED, self)
	Wwise.post_event_id(AK.EVENTS.PERSONAREAENTERED, self)
	person.clown_count += 1

func clown_exited(area: Area2D) -> void:
	var person: Person = area as Person
	if person == null:
		return
	person.clown_count -= 1

func _process(delta: float) -> void:
	var not_done_people: Array[Person] = []
	for person: Person in people:
		if person.is_done():
			remove_child(person)
			person.turn_happy.disconnect(person_turned_happy)
			if not person.was_happy:
				level_ui.missed += 1
				if level_ui.missed >= miss_people_to_lose:
					game_over_ui.show()
					get_tree().paused = true
				Wwise.post_event_id(AK.EVENTS.MUSICFILLFAIL, self)
				Wwise.post_event_id(AK.EVENTS.CLOWNFAIL, self)
		else:
			not_done_people.append(person)
	people = not_done_people
	
	if randf() < 0.01:
		Wwise.post_event_id(AK.EVENTS.CLOWNIDLE, self)
	if randf() < 0.01:
		Wwise.post_event_id(AK.EVENTS.PERSONIDLE, self)
	if randf() < 0.0001:
		Wwise.post_event_id(AK.EVENTS.CLOWNTONGUEWHISTLE, self)
	if randf() < 0.3 * delta:
		spawn_person()
	if clown_to_place != null:
		clown_to_place.position = get_mouse_pos()
		if Input.is_action_just_pressed("click"):
			clown_to_place.area_entered.connect(clown_entered)
			clown_to_place.area_exited.connect(clown_exited)
			clown_to_place.place()
			clowns.append(clown_to_place)
			if clowns.size() > max_clowns:
				remove_child(clowns[0])
				clowns[0].area_entered.disconnect(clown_entered)
				clowns[0].area_exited.disconnect(clown_exited)
				clowns.remove_at(0)
			# Needed as otherwise clown_entered is not called if a person
			# is already in the zone of clown_to_place
			for person: Person in people:
				if clown_to_place.overlaps_area(person):
					clown_entered(person)
			set_new_clown_to_place()

func get_mouse_pos() -> Vector2:
	return get_viewport().get_mouse_position()

func set_new_clown_to_place() -> void:
	clown_to_place = clown_template.instantiate()
	add_child(clown_to_place)
	clown_to_place.initialize(rand_ind(clown_to_place.clown_shapes))
	clown_to_place.position = get_mouse_pos()

func spawn_person() -> void:
	var person: Person = person_template.instantiate()
	add_child(person)
	person.initialize(rand_ind(person.sprites), paths[rand_ind(paths)].curve, 100, 0)
	people.append(person)
	person.turn_happy.connect(person_turned_happy)

func person_turned_happy() -> void:
	level_ui.score += 1
	Wwise.post_event_id(AK.EVENTS.CLOWNSUCCESS, self)
	Wwise.post_event_id(AK.EVENTS.PERSONCONVERTED, self)
	Wwise.post_event_id(AK.EVENTS.MUSICFILLSUCCESS, self)

func rand_ind(array: Array) -> int:
	return randi_range(0, array.size() - 1)

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(GlobalState.main_menu_scene)
