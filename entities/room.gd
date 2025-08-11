class_name Room 
extends Node

signal room_filled(room, users)
signal users_changed(users)

var id: int
var maximum_size: int = 2
var users = []

func add_user(user) -> bool:
	if is_room_full():
		return false
	users.append(user)
	users_changed.emit(users)
	if is_room_full():
		room_filled.emit(id, users)
	return true

func remove_user(user) -> bool:
	if user in users:
		users.erase(user)
		return true 
	return false

func is_room_full() -> bool:
	return users.size() == maximum_size

static func from_dict(dict: Dictionary):
	var room = Room.new()
	room.id= dict["id"]
	for user_dict in dict.keys():
		var user = User.from_dict(user_dict)
		room.users.append(user)
	room.users= dict["id"]
	room.id= dict["id"]
	return room
