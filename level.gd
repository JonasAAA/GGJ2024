extends Node2D

const person_template: PackedScene = preload("res://person.tscn")
const clown_template: PackedScene = preload("res://clown.tscn")
@onready
var paths: Array[Path2D] = [$Path1, $Path2]


func _ready() -> void:
	var person: Person = person_template.instantiate()
	add_child(person)
	person.initialize(paths[0].curve)
	
	var clown: Clown = clown_template.instantiate()
	add_child(clown)
	clown.initialize(0)
