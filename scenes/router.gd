extends Node

signal connect_requested(address: String, username: String)


var battle_scene = preload("res://scenes/game.tscn")
var menu_scene = preload("res://scenes/menu.tscn")
var load_scene = preload("res://scenes/loading.tscn")
var host_scene = preload("res://scenes/host_ui.tscn")
var lobby_scene = preload("res://scenes/lobby.tscn")
var loading_instance

func _ready():
	var menu = menu_scene.instantiate()
	menu.mode_chosen.connect(_on_mode_chosen)
	menu.connect_requested.connect(_on_connect_requested)
	add_child(menu)


func _on_connect_requested(address, username):
	connect_requested.emit(address, username)

func _on_server_starting():
	loading_instance = load_scene.instantiate()
	add_child(loading_instance)

func _on_server_started():
	print("Server started successfully")
	loading_instance.queue_free()
	var host_ui = host_scene.instantiate()
	add_child(host_ui)

func _on_server_failed_to_start(error):
	print("Server failed to start: " + str(error))
	var error_ui = load_scene.instantiate()
	add_child(error_ui)
	error_ui.set_error_message("Failed to start server: " + str(error))

func _on_mode_chosen(mode):
	$Menu.queue_free()
	if mode == "join":
		var load_instance = load_scene.instantiate()
		add_child(load_instance)
	if mode == "official":
		var load_instance = lobby_scene.instantiate()
		add_child(load_instance)
	if mode == "error":
		var load_instance = lobby_scene.instantiate()
		add_child(load_instance)
