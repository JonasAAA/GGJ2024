class_name Clown extends Area2D

var collision_shape: Node2D
@onready
var clown_shapes: Array[Node2D] = [$CollisionShape1, $CollisionShape2]

func _ready() -> void:
	for ind: int in clown_shapes.size():
		set_clown_shape_disabled(ind, true)

func initialize(shape_index: int) -> void:
	collision_shape = clown_shapes[shape_index]
	set_clown_shape_disabled(shape_index, false)
	
func set_clown_shape_disabled(index: int, disabled: bool) -> void:
	var shape: Node2D = clown_shapes[index]
	if shape is CollisionShape2D:
		(shape as CollisionShape2D).disabled = disabled
		(shape as CollisionShape2D).visible = not disabled
	if shape is CollisionPolygon2D:
		(shape as CollisionPolygon2D).disabled = disabled
		(shape as CollisionPolygon2D).visible = not disabled
