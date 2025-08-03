extends Node

func _ready():
	var battle_scene = preload("res://scenes/Battle.tscn")
	var battle = battle_scene.instantiate()
	add_child(battle)
