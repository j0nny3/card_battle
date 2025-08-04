extends Node

var players = {}
var turn_ended = false

func get_player_data_as_dict(player_id) -> Dictionary:
	var player = players.get(player_id)
	var data = {}
	data["health"] = player.health
	data["enemy_health"] = 10
	data["mana"] = player.mana
	data["enemy_mana"] = 10

	var hand_card_id_list: Array
	for card in player.hand :
		hand_card_id_list.append(card.id)
	data["hand"] = hand_card_id_list

	var active_card_id_list: Array
	for card in player.active_cards :
		active_card_id_list.append(card.id)
	data["active_cards"] = active_card_id_list

	var enemy_active_card_id_list: Array
	for card in BattleManager.get_enemy_of(player).active_cards :
		enemy_active_card_id_list.append(card.id)
	data["enemy_active_cards"] = enemy_active_card_id_list

	return data

func sync_data(player_id):
	var data = get_player_data_as_dict(player_id)
	print("sync data to player: " +str(player_id)+ " with data: "+str(data))
	ClientState.sync.rpc_id(player_id, data)
	
