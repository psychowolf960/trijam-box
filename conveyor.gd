extends Node2D

@export var boxes_root: Node
@export var push_velocity := 550.0
@export var scroll_speed := 100.0

@onready var mat = $TextureRect.material

var offset := 0.0

func _process(delta):
	var is_pushing = Input.is_action_pressed("next")
	
	for box in boxes_root.get_children():
		if box.is_in_group("boxes"):
			if is_pushing:
				box.linear_velocity.x = push_velocity

	if is_pushing:
		offset = fmod(offset + scroll_speed * delta / $TextureRect.texture.get_width(), 1.0)
		mat.set("shader_parameter/offset_x", offset)
