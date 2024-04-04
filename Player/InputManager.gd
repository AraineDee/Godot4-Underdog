extends Node

@onready var player = get_parent() as Character

@export var input_dir : Vector2
@export var attack : bool
@export var jump : bool
@export var kill_self : bool

func _input(_event):
	if not player.controlled_here:
		return
	input_dir = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	attack = Input.is_action_just_pressed("Attack")
	jump = Input.is_action_just_pressed("ui_accept")
	kill_self = Input.is_action_just_pressed("KillYourself")
