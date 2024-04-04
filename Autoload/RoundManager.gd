extends Node


signal round_won(id : int)
signal map_won(id : int)


var MapScene = preload("res://Maps/pillars_map.tscn") as PackedScene

var round_length : int = 2

var round_scores = []

var map : Map

var players = []

func _ready():
	map_won.connect(handle_map_win)

#		ROUND INIT AND RESET
func init_round():
	load_map()
	init_scores()

func reset_round():
	reset_map()
	reset_scores()

func reset_scores():
	for p in round_scores:
		p["score"] = 0

func init_scores():
	for p in GameManager.players:
		round_scores.append({
			"id" : p["id"],
			"score" : 0
		})

func start_round():
	for player in players:
		add_player_to_map(player)
	map.start_map()

func add_player(player : Character):
	players.append(player)
	player.died.connect(player_died)

#region	MAP MANAGEMENT
func handle_map_win(winner : int):
	add_score(winner)
	reset_map()
	
func reset_map():
	randomize_map()
	clear_map()
	load_map()
	for player in players:
		add_player_to_map(player)

func randomize_map():
	pass

func load_map():
	map = MapScene.instantiate()
	GameManager.world.add_child(map)

func clear_map():
	map.queue_free()

func add_player_to_map(player : Character):
	map.spawn_player(player)


#		ROUND STATE
func check_map_win():
	var alive_count := 0
	var winner_id := -1 
	for player in players:
		if player.is_alive:
			alive_count += 1
			winner_id = int(str(player.name))
	if alive_count == 1:
		map_won.emit(winner_id)
		check_round_win()

func check_round_win():
	for player in round_scores:
		if player["score"] >= round_length:
			round_won.emit(player["id"])

func player_died(player : Character):
	player.despawn()
	check_map_win()

func get_score_index_from_id(id : int) -> int:
	for i in range(len(round_scores)):
		if round_scores[i]["id"] == id:
			return i
	return -1

func add_score(id : int):
	round_scores[get_score_index_from_id(id)]["score"] += 1 
