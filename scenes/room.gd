extends VBoxContainer


var room_id
var players_in_room: Dictionary

func _ready():
	pass
	#NetworkManager.room_joined.connect(_on_player_entered)_
	#NetworkManager.room_left.connect(_on_player_left)_

func _on_player_entered(player_name):
	var label = Label.new()
	label.text = player_name

func _on_player_left(player_name):
	for child in get_children():
		if child.text == player_name:
			child.queue_free()
