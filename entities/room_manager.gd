extends Node

signal room_created(room_id: int)

var number_of_open_rooms:= 0
var number_of_filled_rooms:= 0
var rooms: Dictionary

var next_room_id := 1

func add_user_to_room(user, room) -> bool:
	var added = rooms.get(room).add_user(user)
	if added:
		ServerState.players.get(user).room = room
	return added


func remove_user_from_rooms(user):
	for room in rooms:
		if room.remove_user(user):
			break
	ServerState.players.get(user).room = 0
	

func create_room() -> Room:
	var room = Room.new()
	next_room_id += 1
	room.id = next_room_id
	rooms[room.id] = room
	room_created.emit(next_room_id)
	return room 

func delete_rooom(room):
	rooms.erase(room)

func rooms_to_dict() -> Dictionary:
	var dict := {}
	print("rooms: "+str(rooms))
	for room in rooms.values(): 
		dict[room.id] = {}
		for user in room.users:
			dict[room.id][user] = PlayerManager.get_username_by_id(user)
	return dict

func rooms_from_dict(rooms_dict: Dictionary) -> Array[Room]:
	var rooms:= []
	for room_dict in rooms_dict.keys():
		var room = Room.from_dict(room_dict)
		rooms.append(room)
	return rooms

