extends Node

var router_scene = preload("res://scenes/router.tscn")
var router_instance
var lobby_manager
var player_manager


func _ready():
	lobby_manager = LobbyManager.new()

	router_instance = router_scene.instantiate()
	router_instance.connect_requested.connect(_on_connect_requested)
	add_child(router_instance)
	NetworkManager.user_connected.connect(_on_player_connected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	NetworkManager.user_disconnected.connect(_on_player_disconnected)
	

func _on_host_selected():
	NetworkManager.create_server()



func _on_connect_requested(address, username):
	NetworkManager.join_server(address, username)


func _on_player_disconnected(user_id):
	print("Player disconnected: " + str(user_id))
	lobby_manager.remove_user(user_id)

func _on_battle_loaded():
	pass

func _on_server_disconnected():
	print("Server disconnected")

func _on_room_filled(room, users):
	pass

func _on_player_connected(peer_id, player_info):
	var user = User.new(peer_id, player_info["username"])
	lobby_manager.add_user(user)
