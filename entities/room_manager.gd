class_name RoomManager
extends Node

var numner_of_rooms: int
var number_of_open_rooms: int
var number_of_filled_rooms: int
var rooms: Array[Room]

var next_room_id := 1
func create_room():
	rooms.append(Room.new())
