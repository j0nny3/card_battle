extends Control

var battle_scene_string = "res://scenes/game.tscn"

func _ready():
	$StartButton.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	NetworkManager.load_game.rpc(battle_scene_string)
