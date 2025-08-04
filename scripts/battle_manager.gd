extends Node

signal card_played

var players = {}
var turn_ended = false

func _ready():
	NetworkManager.player_connected.connect(_on_player_connect)

func get_enemy_of(player_id) -> Player:
	for id in players.keys():
		if id != 1 and id != player_id:
			return players.get(id)
	return null

func _on_player_connect(peer_id,player_info):
	if peer_id == 1 :
		return
	var new_player = Player.new(Player.Type.HUMAN)
	new_player.id = peer_id
	new_player.name = player_info["name"]
	CardManager.load_deck(new_player)
	players[peer_id] = new_player

@rpc("authority", "reliable")
func request_end_turn():
	if turn_ended:
		return

	players.get(multiplayer.get_remote_sender_id()).end_turn = true
	if players.values().all(func(player): player.end_turn):
	#if player2.type == Player.Type.NPC:
	#	simulate_enemy_card()
		turn_ended = true
		var card_id_list = {}
		for id in players:
			var player = players.get(id)
			card_id_list[id] = player.active_cards

		end_turn(card_id_list)
		turn_ended=false

@rpc("reliable", "call_remote", "any_peer")
func display_cards(card_id_list):
	for id in card_id_list:
		var card = CardManager.card_db.get(id)
		card_played.emit(card, false)

# server
func end_turn(card_id_list):
	display_cards.rpc(card_id_list)

	await get_tree().create_timer(3.0).timeout

	resolve_cards()

	for id in players:
		sync_mana.rpc(id)
		draw_card(id)
	
	for player in players.keys():
		var data = {}
		data["health"] = player.health
		data["enemy_health"] = get_enemy_of(player.id).health
		data["mana"] = player.mana
		data["enemy_mana"] = get_enemy_of(player.id).mana
		data["hand"] = player.hand
		data["active_cards"] = player.active_cards

		sync_data.rpc_id(player.id, data)

func draw_card(player_id):
	CardManager.draw(players.get(player_id))


@rpc("reliable", "any_peer","call_remote")
func sync_mana(player_id):
	players.get(player_id).current_mana+=1

@rpc("authority","reliable")
func request_play_card(card_instance_id):
	var caller =players.get(multiplayer.get_remote_sender_id()) 
	var card = CardManager.get_card_by_instance_id(card_instance_id)

	if caller.current_mana < card.cost and caller.hand.any(func(card): card.instance_id == card_instance_id):
		caller.current_mana-=card.cost
		caller.active_cards.append(card)

		response_play_card.rpc_id(caller.id, card_instance_id)

@rpc("reliable","any_peer")
func response_play_card(card_instance_id):
		var card = CardManager.get_card_by_instance_id(card_instance_id)
		players.get(multiplayer.get_unique_id()).current_mana+=card.cost
		card.played.emit()
		card_played.emit(card, true)

func simulate_enemy_card():
	#var card = player2.hand.pick_random()
	#request_play_card(player2, card)
	return

func resolve_cards():
	for id in players:
		for card in players.get(id).active_cards:
			resolve_card(card,players[id])
			card.used.emit()
	for player in players:
		player.active_cards.clear()

@rpc("reliable", "any_peer","call_remote")
func sync_data(data):
	ClientState.health=data.get("health")
	ClientState.enemy_health=data.get("enemy_health")
	ClientState.mana=data.get("mana")
	ClientState.enemy_mana=data.get("enemy_mana")
	ClientState.hand=data.get("hand")
	ClientState.active_cards=data.get("active_cards")

func resolve_card(card, own_player):
	if card.blockable and get_enemy_of(own_player.id).active_card.any(func(_card): card.blocks):
		return
	card.effect.call(own_player,get_enemy_of(own_player.id), card.number, card.number2)
