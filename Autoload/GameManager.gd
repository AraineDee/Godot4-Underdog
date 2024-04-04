extends Node


signal game_won(winner : int)

var WorldScene = preload("res://world.tscn") as PackedScene
var PlayerScene = preload("res://Player/Character.tscn") as PackedScene

var players = []

var world : Node3D

var multiplayer_is_connected := false

var game_length := 3

# Called when the node enters the scene tree for the first time.
func _ready():
	game_won.connect(handle_game_win)
	RoundManager.round_won.connect(handle_round_win)
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connection_failed.connect(connection_failed)


#		MULTIPLAYER
func add_player(player_name, id):
	players.append({
		"id" : id,
		"name" : player_name,
		"score" : 0
	})
	
func peer_connected(id : int):
	print("%d connected" % id)
	add_player("", id)

func peer_disconnected(id : int):
	print("%d connected" % id)
	players.erase(id)

func connection_failed():
	print("connection failed")


#		INIT
func create_player(player : Dictionary) -> Character:
	var player_node = PlayerScene.instantiate() as Character
	player_node.name = str(player["id"])
	world.add_child(player_node)
	return player_node

func start_game():
	world = WorldScene.instantiate() as Node3D
	get_tree().root.add_child(world)
	RoundManager.init_round()
	for p in players:
		var player = create_player(p)
		RoundManager.add_player(player)
	RoundManager.start_round()


#		GAME STATE
func handle_game_win(winner : int):
	print("GAME WON BY %d" % winner)

func handle_round_win(winner : int):
	print("ROUND WON BY %d" % winner)
	add_score(winner)
	check_game_win()
	RoundManager.reset_round()

func check_game_win():
	for p in players:
		if p["score"] >= game_length:
			game_won.emit(p["id"])

func add_score(id : int):
	for p in players:
		if p["id"] == id:
			p["score"] += 1
			return

