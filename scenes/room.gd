extends VBoxContainer

signal join_room_clicked(room_id)

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
		user_label.text = user.id
		user_list.add_child(user_label)


func _on_join_pressed():
	join_room_clicked.emit(room_id)
	join_button.disabled = true
	join_button.text = "Joining..."
	join_button.set_process_input(false)
	join_button.set_process(false)
	
	# Optionally, you can disable the button after joining
	# join_button.disabled = true
	# join_button.text = "Joined"
