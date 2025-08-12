class_name LobbyManager
extends Node

var users: Array[User]

func _init():
	users = []

func add_user(user: User) -> void:
	if user not in users:
		users.append(user)
		print("User added: ", user.name)
	else:
		print("User already exists: ", user.name)

func remove_user(user: User) -> void:
	if user in users:
		users.erase(user)
		print("User removed: ", user.name)
	else:
		print("User not found: ", user.name)
