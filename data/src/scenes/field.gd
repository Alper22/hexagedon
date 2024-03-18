@tool
extends Node3D

const CUBE_HEIGHT : float = 0.2
const CUBE = preload("res://data/src/scenes/cube.tscn")
const MIN : int = 0
const MAX : int = 3
@export_range (MIN, MAX) var max_stack_height : int = 6
var rng = RandomNumberGenerator.new()

func _ready():
	generate_cube_stack()

func generate_cube_stack():
	var stack_height : int = rng.randf_range(0, max_stack_height)
	for i in range(MIN, stack_height):
		var cube = CUBE.instantiate()
		add_child(cube)
		cube.translate(Vector3(0.0, CUBE_HEIGHT * i, 0.0))