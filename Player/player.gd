extends CharacterBody3D

class_name Character

signal took_damage(damage : int)
signal took_knockback(knockback : Vector3)
signal died(player : Character)
signal spawned

const ACCEL := 10.0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var AnimTree : AnimationTree

@onready var InputManager = $InputManager

var is_alive

@onready var HealthManager = $HealthComponent

@onready var CharSync = $CharacterSynchonizer as MultiplayerSynchronizer
@onready var InputSync = $InputSynchronizer as MultiplayerSynchronizer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var controlled_here := false


func _ready():
	pass

func spawn():
	visible = true
	is_alive = true
	check_multiplayer_auth()
	velocity = Vector3.ZERO
	spawned.emit()

func despawn():
	$CamController/Camera3D.clear_current(true)
	visible = false
	is_alive = false


func check_multiplayer_auth():
	CharSync.set_multiplayer_authority(int(str(name)))
	InputSync.set_multiplayer_authority(int(str(name)))
	controlled_here = str(multiplayer.get_unique_id()) == name
	if controlled_here:
		$CamController/Camera3D.current = true
		$Xbot/Armature/Skeleton3D/Beta_Surface.visible = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if InputManager.jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = InputManager.input_dir
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta)
	
	AnimTree.set("parameters/conditions/attack", InputManager.attack)
	if InputManager.attack:
		$PunchHitBox.attack()
	
	if InputManager.kill_self:
		HealthManager.take_damage(100000)
	
	move_and_slide()
