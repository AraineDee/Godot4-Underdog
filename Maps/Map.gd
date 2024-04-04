extends Node3D

class_name Map

@export var spawns_used = 0

@export var BottomWorldBound : Area3D

func reset_map():
	spawns_used = 0
	BottomWorldBound.monitoring = false

func get_random_spawn():
	var spawns = get_tree().get_nodes_in_group("Spawns")
	var spawn = spawns.pick_random()
	while spawn.used:
		spawn = spawns.pick_random()
	spawn.used = true
	return spawn

func spawn_player(player : Character):
	var spawn = get_random_spawn()
	player.position = Vector3(spawn.position)
	player.rotation = Vector3(spawn.rotation)
	spawns_used += 1
	player.spawn()


func start_map():
	if BottomWorldBound != null:
		pass#BottomWorldBound.monitoring = true
