class_name Person extends Area2D

const happiness_per_sec: float = 0.5
const required_happiness: float = 1
const speed: float = 100

@onready
var path: Path2D = $Path
@onready
var path_follow: PathFollow2D = $Path/PathFollow
@onready
var sprite: Sprite2D = $Sprite
var clown_count: int
var progress: float
var happiness: float
var was_happy: bool

signal turn_happy

func initialize(curve: Curve2D) -> void:
	path.curve = curve
	clown_count = 0
	progress = 0
	clown_count = 0
	was_happy = false
	update_position()

func _process(delta: float) -> void:
	happiness += delta * happiness_per_sec * clown_count
	var is_happy: bool = happiness >= required_happiness
	if not was_happy and is_happy:
		turn_happy.emit()
	if is_happy:
		sprite.modulate = Color(0, 1, 0)
	else:
		sprite.modulate = Color(happiness / required_happiness, happiness / required_happiness, 0)
	was_happy = is_happy
	#var strength: float = 1 - clown_count * 0.1
	#sprite.modulate = Color(strength, strength, strength, strength)

func _physics_process(delta: float) -> void:
	progress += delta * speed
	update_position()

func update_position() -> void:
	path_follow.progress = progress
	position = path_follow.position

#func _process(delta: float) -> void:
	#progress += delta * 100
	#print(progress)
	#path_follow.progress = progress

func is_done() -> bool:
	return progress >= path.curve.get_baked_length()

