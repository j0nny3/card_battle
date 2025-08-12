extends VBoxContainer

var connected_player_labels = []

func _ready():
	NetworkManager.user_connected.connect(_on_player_connected)
	NetworkManager.user_disconnected.connect(_on_player_disconnected)

func _on_player_connected(peer_id, player_info):
	var label = Label.new()
	label.text = str(peer_id) + ": "+ player_info["username"]
	add_child(label)
	connected_player_labels.append(label)

func _on_player_disconnected(peer_id):
	for label in connected_player_labels:
		if label.text.begins_with(str(peer_id))  :
			label.queue_free()
