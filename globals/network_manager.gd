extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal user_connected(peer_id, player_info)
signal server_disconnected
signal user_disconnected(peer_id)

const PORT = 4242
const DEFAULT_SERVER_IP = "127.0.0.1"

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}
# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"username": "Name"}

var players_loaded = 0
var battle_scene_string = "res://scenes/game.tscn"

func _ready():
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func join_server(address: String = DEFAULT_SERVER_IP, username = "Player"):
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	player_info["username"] = username

@rpc("reliable", "any_peer")
func request_join_room(_room_id):
	pass


func _on_connected_ok():
	print("request name set")
	request_set_Player_info.rpc_id(1, player_info)

@rpc("reliable", "any_peer")
func request_set_Player_info(_player_info):
	pass
	
@rpc("reliable")
func load_game(game_scene_path ):
	pass


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

@rpc("reliable")
func publish_room_list(_rooms: Dictionary):
	ClientState.rooms_changed.emit(_rooms)

