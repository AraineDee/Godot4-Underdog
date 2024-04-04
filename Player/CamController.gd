extends Node3D


var player : CharacterBody3D
@export var sensitivity := 3

@onready var Cam = $Camera3D as Camera3D
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent() as Node3D
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if not player.controlled_here:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		player.rotate(Vector3.UP, -1 * event.relative.x / 1000 * sensitivity)
		Cam.rotation.x -= event.relative.y / 1000 * sensitivity
		Cam.rotation.x = clamp(Cam.rotation.x, -1, 1)
		
	if event.is_action_pressed("Escape"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
