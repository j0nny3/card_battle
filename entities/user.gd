class_name User
extends Node

signal username_changed(new_name: String) 

var id
var username:
	set(new_value):
		username = new_value
		username_changed.emit(new_value)
