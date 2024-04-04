extends Node

class_name HealthComponent

@onready var player = get_parent() as Character

@export var max_health := 10

var damage_taken := 0

func take_damage(damage: int):
	damage_taken += damage
	if damage_taken >= max_health:
		player.died.emit(player)


func reset_health():
	damage_taken = 0
