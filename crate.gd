extends Node2D

var approved: bool = false
var in_machine: bool = false

@onready var background: Sprite2D = $inside
@onready var cover: Sprite2D = $Cover
@onready var reveal_area: Sprite2D = %revealArea

@export var dangerous: bool = false
@export var reveal_mode: int = 1
@export var feather: float = 20.0
@export var reveal_size: Vector2 = Vector2(550.0, 400.0)

var cover_material: ShaderMaterial

func _ready():
	cover_material = ShaderMaterial.new()
	var shader = load("res://xray.gdshader")
	cover_material.shader = shader
	cover.material = cover_material
	
	cover_material.set_shader_parameter("reveal_mode", reveal_mode)
	cover_material.set_shader_parameter("feather", feather)
	cover_material.set_shader_parameter("reveal_size", reveal_size)

func _process(_delta):
	if reveal_area and cover_material:
		var viewport = get_viewport()
		var canvas_transform = viewport.get_canvas_transform()
		var screen_pos = canvas_transform * reveal_area.global_position
		cover_material.set_shader_parameter("reveal_world_position", screen_pos)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("destroy"):
		if in_machine:
			queue_free()


func _on_colision_area_entered(area: Area2D) -> void:
	if area.is_in_group("xray_machine"):
		if not approved:
			in_machine = true

	if area.is_in_group("approval_wall"):
		if approved:
			return

		approved = true
		in_machine = false

		if dangerous:
			Globals.failures += 1
		else:
			Globals.sucesses += 1

func _on_colision_area_exited(area: Area2D) -> void:
	if area.is_in_group("xray_machine"):
		in_machine = false
