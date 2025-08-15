extends Node

var network_manager_scene = preload("res://scenes/network_manager.tscn")
var router_scene = preload("res://scenes/router.tscn")
var router_instance
var network_manager
var room_manager
var lobby_manager
var server_state
var player_manager


func _ready():
	room_manager = RoomManager.new(server_state)
	lobby_manager = LobbyManager.new()

	router_instance = router_scene.instantiate()
	router_instance.host_selected.connect(_on_host_selected)
	add_child(router_instance)
	instance_network_manager()
	

func _on_host_selected():
	network_manager.create_server()

func instance_network_manager():
	if not network_manager:
		network_manager = network_manager_scene.instantiate()
		network_manager.server_state = server_state
		network_manager.room_manager = room_manager
		network_manager.user_connected.connect(_on_player_connected)
		network_manager.server_disconnected.connect(_on_server_disconnected)
		network_manager.user_disconnected.connect(_on_player_disconnected)
		network_manager.server_started.connect(router_instance._on_server_started)
		network_manager.server_starting.connect(router_instance._on_server_starting)
		network_manager.server_failed_to_start.connect(router_instance.router_instance._on_server_failed_to_start)

		add_child(network_manager)
func _on_connect_requested(address, username):
	network_manager.join_server(address, username)


func _on_player_disconnected(user_id):
	print("Player disconnected: " + str(user_id))
	lobby_manager.remove_user(user_id)
	room_manager.remove_user_from_rooms(user_id)


func _on_battle_loaded():
	pass

func _on_server_disconnected():
	print("Server disconnected")

func _on_room_filled(room, users):
	pass

func _on_player_connected(peer_id, player_info):
	var user = User.new(peer_id, player_info["username"])
	lobby_manager.add_user(user)
