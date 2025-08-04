extends Node

signal card_played

func _ready():
	NetworkManager.player_connected.connect(_on_player_connect)

func get_enemy_of(player_id) -> Player:
	for id in ServerState.players.keys():
		if id != 1 and id != player_id:
			return ServerState.players.get(id)
	return null

func _on_player_connect(player_id, player_info):
	if player_id == 1 :
		return
	if multiplayer.get_unique_id() == 1:
		var new_player = Player.new(Player.Type.HUMAN)
		new_player.id = player_id
		new_player.name = player_info["name"]
		CardManager.load_deck(new_player)
		ServerState.players[player_id] = new_player
		print(new_player)
		draw_cards(player_id, 5)

		ServerState.sync_data(player_id)

@rpc("authority", "reliable")
func request_end_turn():
	if ServerState.turn_ended:
		return

	ServerState.players.get(multiplayer.get_remote_sender_id()).end_turn = true
	if ServerState.players.values().all(func(player): player.end_turn):
	#if player2.type == Player.Type.NPC:
	#	simulate_enemy_card()
		ServerState.turn_ended = true
		var card_id_list = {}
		for id in ServerState.players:
			var player = ServerState.players.get(id)
			card_id_list[id] = player.active_cards

		end_turn(card_id_list)
		ServerState.turn_ended=false

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

	for player_id in ServerState.players:
		draw_cards(player_id)
		ServerState.sync_data(player_id)
		ServerState.players.get(player_id).mana+=1

func draw_cards(player_id, n=1):
	CardManager.draw(ServerState.players.get(player_id), n)

@rpc("authority","reliable")
func request_play_card(card_instance_id):
	var caller =ServerState.players.get(multiplayer.get_remote_sender_id()) 
	var card = CardManager.get_card_by_instance_id(card_instance_id)

	if caller.mana < card.cost and caller.hand.any(func(card): card.instance_id == card_instance_id):
		caller.mana-=card.cost
		caller.active_cards.append(card)

		response_play_card.rpc_id(caller.id, card_instance_id)

@rpc("reliable","any_peer")
func response_play_card(card_instance_id):
		var card = CardManager.get_card_by_instance_id(card_instance_id)
		ServerState.players.get(multiplayer.get_unique_id()).mana+=card.cost
		card.played.emit()
		card_played.emit(card, true)

func simulate_enemy_card():
	#var card = player2.hand.pick_random()
	#request_play_card(player2, card)
	return

func resolve_cards():
	for id in ServerState.players:
		for card in ServerState.players.get(id).active_cards:
			resolve_card(card,ServerState.players[id])
			card.used.emit()
	for player in ServerState.players:
		player.active_cards.clear()

func resolve_card(card, own_player):
	if card.blockable and get_enemy_of(own_player.id).active_card.any(func(_card): card.blocks):
		return
	card.effect.call(own_player,get_enemy_of(own_player.id), card.number, card.number2)
