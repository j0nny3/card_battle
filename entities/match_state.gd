class_name MatchState
extends Node

var players = {}
var turn_ended = false

func get_enemy_of(player: Player) -> Player:
	if player.type == Player.Type.HUMAN:
		for p in players.values():
			if p.id != player.id and p.type == Player.Type.HUMAN:
				return p
	return null

func get_public_player_data_as_dict(player_id) -> Dictionary:
	var player = players.get(player_id)
	var data = {}
	data["health"] = player.health

	if get_enemy_of(player):
		data["enemy_health"] = get_enemy_of(player).health
		
	data["mana"] = player.mana

	var hand_card_id_list: Array
	for card in player.hand :
		hand_card_id_list.append(card.id)
	data["hand"] = hand_card_id_list

	var active_card_id_list: Array
	for card in player.active_cards :
		active_card_id_list.append(card.id)
	data["active_cards"] = active_card_id_list

	#move enemy mana to private method
	if get_enemy_of(player):
		data["enemy_mana"] = get_enemy_of(player).mana


	return data

func sync_without_enemy_mana(player_id):
	var data = get_public_player_data_as_dict(player_id)
	data.erase("enemy_mana")
	print("sync data to player: " +str(player_id)+ " with data: "+str(data))
	ClientState.sync.rpc_id(player_id, data)

func sync_public_data(player_id):
	var data = get_public_player_data_as_dict(player_id)
	print("sync data to player: " +str(player_id)+ " with data: "+str(data))
	ClientState.sync.rpc_id(player_id, data)
	
func reveal_enemy_active_cards():
	var data = {}
	for player in players.values():
		if get_enemy_of(player) :
			var enemy_active_card_id_list: Array
			for card in get_enemy_of(player).active_cards :
				enemy_active_card_id_list.append(card.id)
			data["enemy_active_cards"] = enemy_active_card_id_list
			ClientState.reveal.rpc_id(player.id, data)
