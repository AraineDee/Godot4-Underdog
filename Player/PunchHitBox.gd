extends Area3D

@onready var player = get_parent()

var extension_shape_damage : int = 3
var extension_shape_begin : float = 0.0
var extension_shape_duration : float = 0.25
var extension_shape_knockback : Vector3 = Vector3.FORWARD + Vector3.UP * 0.2

var connection_shape_damage : int = 5
var connection_shape_begin : float = 0.2
var connection_shape_duration : float = 0.1
var connection_shape_knockback : Vector3 = Vector3.UP + Vector3.FORWARD


var is_attacking := false

#time since attack began
var time_since_attack : float

#duration of entire attack
var attack_length : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)


func attack():
	if is_attacking:
		return
	time_since_attack = 0
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_since_attack >= attack_length:
		set_process(false)
		return
	
	if time_since_attack >= extension_shape_begin:
		$ExtensionShape.disabled = false
	
	if time_since_attack >= connection_shape_begin:
		$ConnectionShape.disabled = false
	
	
	if time_since_attack >= extension_shape_begin + extension_shape_duration:
		$ExtensionShape.disabled = true
	
	if time_since_attack >= connection_shape_begin + connection_shape_duration:
		$ConnectionShape.disabled = true
	
	
	time_since_attack += delta

func is_self(area : Hurtbox):
	return area.player.name == player.name

func _on_hit(_area_rid, area, _area_shape_index, local_shape_index):
	if area is Hurtbox and not is_self(area):
		#gets the local shape that collided 
		if shape_owner_get_owner(shape_find_owner(local_shape_index)).name == "ExtensionShape":
			area.on_hit(extension_shape_damage, extension_shape_knockback.rotated(Vector3.UP, player.rotation.y))
		else:
			area.on_hit(connection_shape_damage, connection_shape_knockback.rotated(Vector3.UP, player.rotation.y))
