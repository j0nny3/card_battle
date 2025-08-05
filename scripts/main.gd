extends Node

var battle_scene = preload("res://scenes/battle.tscn")
var menu_scene = preload("res://scenes/menu.tscn")
var load_scene = preload("res://scenes/loading.tscn")
var host_scene = preload("res://scenes/host_ui.tscn")
var lobby_scene = preload("res://scenes/lobby.tscn")

func _ready():
	var menu = menu_scene.instantiate()
	add_child(menu)
	$Menu.mode_chosen.connect(_on_mode_chosen)

func _on_mode_chosen(mode):
	$Menu.queue_free()
	if mode == "host":
		var host_instance = host_scene.instantiate()
		add_child(host_instance)
	if mode == "offline":
		var battle_instance = battle_scene.instantiate()
		add_child(battle_instance)
	if mode == "join":
		var load_instance = load_scene.instantiate()
		add_child(load_instance)
	if mode == "official":
		var load_instance = lobby_scene.instantiate()
		add_child(load_instance)


