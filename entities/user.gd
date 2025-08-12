class_name User
extends Node

signal username_changed(new_name: String) 

var id
var match_id: int = -1
var username:
	set(new_value):
		username = new_value
		username_changed.emit(new_value)

func _init(_id = 0, _username = "Guest"):
	self.id = _id
	self.username = _username

static func from_dict(dict) -> User:
	var user = User.new()
	user.id = dict["id"]
	user.username = dict["username"]
	return user
