extends VBoxContainer

@onready var user_list = $UserList
@onready var join_button = $JoinRoomButton
@onready var room_id_label = $RoomId
var room_id
var users

func _ready():
	room_id_label.text = str(room_id)
	join_button.pressed.connect(_on_join_pressed)
	for user in users:
		var user_label = Label.new()
		var username = NetworkManager.players.get(user).get("username")
		user_label.text = username
		user_list.add_child(user_label)


func _on_join_pressed():
	NetworkManager.request_join_room.rpc_id(1, room_id)
