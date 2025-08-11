extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 4242
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 3

# This will contain player info for every player,
# with the keys being each player's unique IDs.
var players = {}
var rooms = {}
# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"username": "Name"}

var players_loaded = 0
var battle_scene_string = "res://scenes/game.tscn"

func _ready():
	var args = OS.get_cmdline_args()
	if "--server" in args :
		create_game()
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

@rpc("reliable", "any_peer")
func request_join_room(room_id):
	var user_id = multiplayer.get_remote_sender_id()
	var added = RoomManager.add_user_to_room(user_id, room_id)
	for player in ServerState.players:
		update_rooms(player)
	return added
	

func join_server(address = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	RoomManager.create_room()
	print("created server")

# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
@rpc("reliable")
func load_game(game_scene_path):
	get_tree().change_scene_to_file(game_scene_path)


# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size() and players_loaded == 2:
			#could wait to actually start till load here
			#$/root/main.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(user_id):
	print("player connected, user_id:" +str(user_id))
	if multiplayer.get_unique_id() == 1:
		update_rooms(user_id)
	_register_player.rpc_id(user_id, player_info)

func update_rooms(user_id):
	publish_room_list.rpc_id(user_id, RoomManager.rooms_to_dict())
	
@rpc("reliable")
func publish_room_list(_rooms: Dictionary):
	print("update rooms for "+str(multiplayer.get_unique_id()))
	#var parsed_rooms = RoomManager.rooms_from_dict(_rooms)
	#print(parsed_rooms)
	#ClientState.rooms = parsed_rooms
	ClientState.rooms = _rooms


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	if new_player_id == 1:
		return #dont want server to add itself
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	ServerState.reset_state()

func _on_connected_ok():
	#dont let server message other people
#	if multiplayer.get_unique_id() == 1:
#		return
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
