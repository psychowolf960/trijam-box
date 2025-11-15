extends Node2D

@onready var background: Sprite2D = $inside
@onready var cover: Sprite2D = $Cover
@onready var reveal_area: Sprite2D = %revealArea

@export var reveal_mode: int = 1
@export var feather: float = 0.0
@export var reveal_size: Vector2 = Vector2(550.0, 400.0)
@export var reveal_position: Vector2 = Vector2(540.0, 230.0)
@export var follow_mouse: bool = false

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
		cover_material.set_shader_parameter("reveal_world_position", reveal_area.global_position)
		cover_material.set_shader_parameter("cover_world_position", cover.global_position)
		
		if reveal_area.texture:
			var texture_size = reveal_area.texture.get_size() * reveal_area.scale
			cover_material.set_shader_parameter("reveal_size", texture_size)

func _input(event):
	if follow_mouse and event is InputEventMouseMotion:
		reveal_area.global_position = event.position
