class_name NetworkManager
extends Node

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal user_connected(peer_id, player_info)
signal user_disconnected(peer_id)
signal server_disconnected
signal server_starting
signal server_started()
signal server_failed_to_start(error)

const PORT = 4242
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 13

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
var server_state
var room_manager

@rpc("reliable", "any_peer")
func request_join_room(_room_id):
	pass

func create_server():
	server_starting.emit()
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		server_failed_to_start.emit(error)
		return error
	multiplayer.multiplayer_peer = peer
	room_manager.create_room()
	print("created server")
	server_started.emit()

@rpc("reliable")
func load_game(game_scene_path = battle_scene_string):
	get_tree().change_scene_to_file(game_scene_path)

# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(user_id):
	print("player connected, user_id:" +str(user_id))
	if multiplayer.get_unique_id() == 1:
		update_room(user_id)
	_register_player.rpc_id(user_id, player_info)

func update_rooms():
	for user_id in server_state.players:
		update_room(user_id)
	
func update_room(user_id):
	publish_room_list.rpc_id(user_id, room_manager.rooms_to_dict())

@rpc("reliable")
func publish_room_list(_rooms: Dictionary):
	print("update rooms for "+str(multiplayer.get_unique_id()))
	#var parsed_rooms = room_manager.rooms_from_dict(_rooms)
	#print(parsed_rooms)
	#ClientState.rooms = parsed_rooms
	ClientState.rooms = _rooms


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	if new_player_id == 1:
		return #dont want server to add itself
	players[new_player_id] = new_player_info
	user_connected.emit(new_player_id, new_player_info)

func _on_user_disconnected(id):
	if multiplayer.is_server():
		user_disconnected.emit(id)
		room_manager.remove_user_from_rooms(id)
		update_rooms()

func _on_connected_ok():
	#dont let server message other people
#	if multiplayer.get_unique_id() == 1:
#		return
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	user_connected.emit(peer_id, player_info)


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
