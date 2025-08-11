extends Control

var rooms
var room_scene = preload("res://scenes/room.tscn")
@onready var h_box = $Hbox

func _ready():
	rooms = ClientState.rooms
	ClientState.rooms_changed.connect(_on_rooms_changed)
	update_room_list(rooms)

func _on_rooms_changed(rooms):
	update_room_list(rooms)

func update_room_list(rooms: Dictionary):
	for child in h_box.get_children():
		child.queue_free()

	for room_key in rooms:
		var users = rooms.get(room_key)
		var room_instance = room_scene.instantiate()
		room_instance.room_id = room_key
		room_instance.name = str(room_key)
		room_instance.users = users
		h_box.add_child(room_instance, true)
	
