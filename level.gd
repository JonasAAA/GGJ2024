extends Node2D

var person_template: PackedScene = preload("res://person.tscn")
var clown_template: PackedScene = preload("res://clown.tscn")


func _ready() -> void:
	var person: Person = person_template.instantiate()
	add_child(person)
	person.initialize(load("res://paths/1.tres"))


func _process(delta: float) -> void:
	pass
