class_name Room 
extends Node

signal room_filled(users: Array[User])
signal users_changed(users: Array[User])

var id: int
var maximum_size: int = 2
var users: Array[User]

func add_user(user) -> bool:
	if is_room_full():
		return false
	users.append(user)
	users_changed.emit(users)
	if is_room_full():
		room_filled.emit(users)
	return true

func remove_user(user) -> bool:
	if user in users:
		users.erase(user)
		return true 
	return false

func is_room_full() -> bool:
	return users.size() == maximum_size
