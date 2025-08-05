extends Node

signal card_played

func _ready():
	NetworkManager.player_connected.connect(_on_player_connect)

func get_enemy_of(player: Player) -> Player:
	for id in ServerState.players.keys():
		if id != 1 and id != player.id:
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

@rpc("any_peer", "reliable")
func request_end_turn():
	if ServerState.turn_ended:
		return

	ServerState.players.get(multiplayer.get_remote_sender_id()).ended_turn = true
	if ServerState.players.values().all(func(player): return player.ended_turn):
	#if player2.type == Player.Type.NPC:
	#	simulate_enemy_card()
		ServerState.turn_ended = true
		var card_id_list = {}
		for id in ServerState.players:
			var player = ServerState.players.get(id)
			card_id_list[id] = player.active_cards

		end_turn()
		ServerState.turn_ended=false

# server
func end_turn():
	ServerState.reveal_enemy_active_cards()

	await get_tree().create_timer(3.0).timeout

	resolve_cards()

	for player in ServerState.players.values():
		player.ended_turn = false
		draw_cards(player.id)
		ServerState.players.get(player.id).mana+=1
	for player in ServerState.players.values():
		ServerState.sync_data(player.id)
	print("turn ended")

func draw_cards(player_id, n=1):
	CardManager.draw(ServerState.players.get(player_id), n)

@rpc("any_peer","reliable")
func request_play_card(card_id):
	var caller = ServerState.players.get(multiplayer.get_remote_sender_id()) 
	var card = CardManager.card_db.get(card_id)
	var x
	#x.abs()
	if caller.mana >= card.cost and caller.hand.any(func(card): return card.id == card_id):
		caller.mana-=card.cost
		caller.active_cards.append(card)

		for hand_card in caller.hand:
			if hand_card.id == card_id:
				caller.hand.erase(hand_card)
				break
	ServerState.sync_data(caller.id)

func simulate_enemy_card():
	#var card = player2.hand.pick_random()
	#request_play_card(player2, card)
	return

func resolve_cards():
	for id in ServerState.players:
		for card in ServerState.players.get(id).active_cards:
			resolve_card(card ,ServerState.players[id])
			card.used.emit()
	for player in ServerState.players.values():
		player.active_cards.clear()

func resolve_card(card, own_player):
	if card.blockable and get_enemy_of(own_player).active_cards.any(func(_card): return card.blocks):
		return
	if card.risky and get_enemy_of(own_player).active_cards.any(func(_card): return  card.blockable):
		return
	card.effect.call(own_player,get_enemy_of(own_player), card.number, card.number2)
