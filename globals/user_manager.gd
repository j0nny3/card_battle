extends Node

func get_username_by_id(id):
	return ServerState.players[id].get("username")
