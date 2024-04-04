extends Control

var address = "192.168.1.235"
var port := 8910

var peer : ENetMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready():
	peer = ENetMultiplayerPeer.new()

@rpc("authority", "call_remote")
func play():
	if not GameManager.multiplayer_is_connected:
		dummy_peer()
	if multiplayer.is_server():
		play.rpc()
	GameManager.start_game()
	queue_free()

func dummy_peer():
	peer.create_server(0, 1)
	multiplayer.multiplayer_peer = peer
	GameManager.multiplayer_is_connected = true
	GameManager.add_player("", multiplayer.get_unique_id())

func host():
	peer.create_server(port, 32)
	multiplayer.multiplayer_peer = peer
	GameManager.multiplayer_is_connected = true
	GameManager.add_player("", multiplayer.get_unique_id())

func join():
	peer.create_client(address, port)
	multiplayer.multiplayer_peer = peer
	GameManager.multiplayer_is_connected = true
	GameManager.add_player("", multiplayer.get_unique_id())
