extends Node2D

@export var boxes_root: Node
@export var push_velocity := 650.0
@export var scroll_speed := 100.0
@export var push_time := 0.8

@onready var mat = $TextureRect.material
var texture_offset := 0.0
var pushing := false
func _input(event):
	if Input.is_action_just_pressed("next"):
		next_box()

var offset := 0.0

func _process(delta):
	if pushing:
		offset = fmod(offset + scroll_speed * delta / $TextureRect.texture.get_width(), 1.0)
		mat.set("shader_parameter/offset_x", offset)
func next_box():
	pushing = true

	for box in boxes_root.get_children():
		if box.is_in_group("boxes"):
			box.linear_velocity.x = push_velocity

	await get_tree().create_timer(push_time).timeout

	pushing = false

	for box in boxes_root.get_children():
		if box.is_in_group("boxes"):
			box.linear_velocity = Vector2.ZERO
