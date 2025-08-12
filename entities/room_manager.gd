class_name RoomManager
extends Node

signal room_created(room_id: int)
signal room_filled(room, users)

var server_state: ServerState

var next_room_id := 1

func _init(_server_state):
	server_state = _server_state
	create_room()

func add_user_to_room(user_id: int, room_id: int) -> bool:
	var room = server_state.rooms.get(room_id)
	if room:
		var user = server_state.players.get(user_id)
		if user and room.add_user(user):
			return true
	return false

func remove_user_from_rooms(user):
	for room in server_state.rooms:
		if server_state.rooms.get(room).remove_user(user):
			break
	
func create_room() -> Room:
	var room = Room.new()
	next_room_id += 1
	room.id = next_room_id
	server_state.rooms[room.id] = room
	room_created.emit(next_room_id)
	room.room_filled.connect(_on_room_filled)
	return room 

func _on_room_filled(room, users):
	room_filled.emit(room, users)

func delete_rooom(room):
	server_state.rooms.erase(room)

func rooms_to_dict() -> Dictionary:
	var dict := {}
	print("server_state.rooms: "+str(server_state.rooms))
	for room in server_state.rooms.values(): 
		dict[room.id] = {}
		for user in room.users:
			dict[room.id][user] = user
	return dict

func rooms_from_dict(rooms_dict: Dictionary) -> Array[Room]:
	var rooms:= []
	for room_dict in server_state.rooms_dict.keys():
		var room = Room.from_dict(room_dict)
		server_state.rooms.append(room)
	return server_state.rooms

func get_enemies(user_id) -> Array[int]:
	var room_id = server_state.players.get(user_id).room
	var players = server_state.rooms.get(room_id).values().duplicate()
	players.erase(user_id)
	return players.values().keys()
	
