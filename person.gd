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

enum PersonSpeed {
	SLOW,
	MEDIUM,
	FAST
}

enum PersonStartingMood {
	SAD,
	OK,
	HAPPY
}

# Using this instead of global_state directly makes GDScript understand that GlobalState is of type GlobalStateType, not Node
var global_state: GlobalStateType = GlobalState
@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
#@onready var personConfigs: Array[PersonConfig] = [
	#PersonConfig.new($Sprite0 as Sprite2D, 100),
	#PersonConfig.new($Sprite1 as Sprite2D, 200),
	#PersonConfig.new($Sprite2 as Sprite2D, 50),
	#PersonConfig.new($Sprite3 as Sprite2D, 100),
#]
@onready var slow_sprites: Array[Sprite2D] = [$Sprite2]
@onready var medium_sprites: Array[Sprite2D] = [$Sprite0, $Sprite3]
@onready var fast_sprites: Array[Sprite2D] = [$Sprite1]
@onready var sprite: Sprite2D = $transform/sprite_visitor
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var emotion_indicator_player: AnimationPlayer = $AnimationPlayerEmotionIndicator
var speed: float

var clown_count: int
var progress: float
var happiness: float
var was_happy: bool

signal turn_happy

func get_config(person_speed: PersonSpeed) -> PersonConfig:
	var sprite_array: Array[Sprite2D] = []
	var local_speed: float = 0
	match person_speed:
		PersonSpeed.SLOW:
			sprite_array = slow_sprites
			local_speed = 50
		PersonSpeed.MEDIUM:
			sprite_array = medium_sprites
			local_speed = 100
		PersonSpeed.FAST:
			sprite_array = fast_sprites
			local_speed = 200
	assert(sprite_array.size() != 0)
	assert(local_speed != 0)
	return PersonConfig.new(sprite_array[global_state.rand_ind(sprite_array)], local_speed)

func get_happiness(mood: PersonStartingMood) -> float:
	match mood:
		PersonStartingMood.SAD:
			return 0
		PersonStartingMood.OK:
			return 0.25
		PersonStartingMood.HAPPY:
			return 0.5
	return 0

func initialize(person_speed: PersonSpeed, starting_mood: PersonStartingMood, curve: Curve2D) -> void:
	var personConfig: PersonConfig = get_config(person_speed)
	sprite.texture = personConfig.texture
	path.curve = curve
	speed = personConfig.speed
	happiness = get_happiness(starting_mood)
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
		# So that it transitions to the last animation frame for sure
		emotion_indicator_player.seek(1.1, true)
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

