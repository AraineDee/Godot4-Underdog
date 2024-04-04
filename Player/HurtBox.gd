extends Area3D

class_name Hurtbox

@onready var player = get_parent() as Character

var in_iframes := false
var iframes_duration := 0.3

var since_hit : float
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if since_hit >= iframes_duration:
		in_iframes = false
		set_process(false)
		return
	
	since_hit += delta



func on_hit(damage : int, knockback : Vector3):
	if in_iframes:
		return
	player.took_knockback.emit(knockback)
	player.velocity += knockback * damage
	player.took_damage.emit(damage)
	in_iframes = true
	since_hit = 0
	set_process(true)
