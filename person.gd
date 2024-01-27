class_name Person extends Node2D

@onready
var path = $Path
@onready
var path_folow = $Path/PathFollow

var progress: float = 0

func _ready() -> void:
	pass

func initialize(curve: Curve2D) -> void:
	path.curve = curve

func _physics_process(delta: float) -> void:
	progress += delta * 100
	path_folow.progress = progress
	position = path_folow.position

#func _process(delta: float) -> void:
	#progress += delta * 100
	#print(progress)
	#path_folow.progress = progress
