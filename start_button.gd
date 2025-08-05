extends Button

var battle_scene_string = "res://scenes/battle.tscn"

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	NetworkManager.load_game.rpc(battle_scene_string)
