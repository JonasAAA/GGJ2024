class_name Person extends Area2D

const happiness_per_sec: float = 0.5

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var sprites: Array[Sprite2D] = [$Sprite0, $Sprite1, $Sprite2, $Sprite3]
var sprite: Sprite2D
var speed: float = 100
var required_happiness: float = 1

var clown_count: int
var progress: float
var happiness: float
var was_happy: bool

signal turn_happy

func initialize(spriteInd: int, curve: Curve2D, _speed: float, _required_happiness: float) -> void:
	sprite = sprites[spriteInd]
	sprite.visible = true
	path.curve = curve
	#sprite.texture = texture
	speed = _speed
	required_happiness = _required_happiness
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

