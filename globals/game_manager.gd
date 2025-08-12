extends Node

var network_manager
var room_manager
var lobby_manager
var server_state
var player_manager

func _ready():
	server_state = ServerState.new()
	#player_manager = PlayerManager.new(server_state)
	room_manager = RoomManager.new(server_state)
	network_manager = NetworkManager.new(server_state, room_manager)
	lobby_manager = LobbyManager.new()
	network_manager.user_connected.connect(_on_player_connected)
	room_manager.room_filled.connect(_on_room_filled)
	network_manager.server_disconnected.connect(_on_server_disconnected)
	network_manager.user_disconnected.connect(_on_player_disconnected)

func _on_player_disconnected(user_id):
	print("Player disconnected: " + str(user_id))
	lobby_manager.remove_user(user_id)
	room_manager.remove_user_from_rooms(user_id)

func _on_server_disconnected():
	print("Server disconnected")

func _on_room_filled(room, users):
	pass

func _on_player_connected(peer_id, player_info):
	var user = User.new(peer_id, player_info["username"])
	lobby_manager.add_user(user)
