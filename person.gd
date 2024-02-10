class_name Person extends Area2D

class PersonConfig:
	var texture: Texture2D
	var speed: float
	
	func _init(sprite: Sprite2D, _speed: float) -> void:
		assert(sprite != null)
		texture = sprite.texture
		speed = _speed

const happiness_per_sec: float = 0.5
const required_happiness: float = 1

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var personConfigs: Array[PersonConfig] = [
	PersonConfig.new($Sprite0 as Sprite2D, 100),
	PersonConfig.new($Sprite1 as Sprite2D, 200),
	PersonConfig.new($Sprite2 as Sprite2D, 50),
	PersonConfig.new($Sprite3 as Sprite2D, 100),
]
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

func initialize(configInd: int, curve: Curve2D, _starting_happiness: float) -> void:
	sprite.texture = personConfigs[configInd].texture
	path.curve = curve
	speed = personConfigs[configInd].speed
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
	position = path_follow.position - Vector2(0, 58)

#func _process(delta: float) -> void:
	#progress += delta * 100
	#print(progress)
	#path_follow.progress = progress

func is_done() -> bool:
	return progress >= path.curve.get_baked_length()

