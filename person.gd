class_name Person extends Node2D

@onready
var path: Path2D = $Path
@onready
var path_folow: PathFollow2D = $Path/PathFollow

var progress: float = 0

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
