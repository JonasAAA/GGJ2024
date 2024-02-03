class_name Person extends Area2D

const happiness_per_sec: float = 0.5
const required_happiness: float = 1

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var sprites: Array[Sprite2D] = [$Sprite0, $Sprite1, $Sprite2, $Sprite3]
@onready var sprite: Sprite2D = $transform/sprite_visitor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emotion_indicator_player: AnimationPlayer = $AnimationPlayerEmotionIndicator
var speed: float
var starting_happiness: float

var clown_count: int
var progress: float
var happiness: float
var was_happy: bool

signal turn_happy

func initialize(spriteInd: int, curve: Curve2D, _speed: float, _starting_happiness: float) -> void:
	sprite.texture = sprites[spriteInd].texture
	path.curve = curve
	speed = _speed
	starting_happiness = _starting_happiness
	clown_count = 0
	progress = 0
	clown_count = 0
	was_happy = false
	update_position()
	animation_player.play("walking_normal")
	emotion_indicator_player.play("anim_laugh")
	emotion_indicator_player.pause()

func _process(delta: float) -> void:
	happiness += delta * happiness_per_sec * clown_count
	var is_happy: bool = happiness >= required_happiness
	
	if not was_happy and is_happy:
		animation_player.play("walking_happy")
		turn_happy.emit()
	if is_happy:
		emotion_indicator_player.pause()
	else:
		emotion_indicator_player.seek(happiness / required_happiness, true)
		emotion_indicator_player.play("anim_laugh")
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

