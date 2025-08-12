class_name MatchManager
extends Node

var card_manager
var match_state

func _init():
	match_state = MatchState.new()
	card_manager = CardManager.new()
	for player in match_state.players.values():

		card_manager.load_deck(player)

func _on_player_connect(player_id, player_info):
	if player_id == 1 :
		return
	if multiplayer.get_unique_id() == 1:
		var new_player = Player.new(Player.Type.HUMAN)
		new_player.id = player_id
		new_player.name = player_info["username"]
		card_manager.load_deck(new_player)
		draw_cards(player_id, 5)

		match_state.sync_public_data(player_id)

@rpc("any_peer", "reliable")
func request_end_turn():
	if match_state.turn_ended:
		return

	match_state.players.get(multiplayer.get_remote_sender_id()).ended_turn = true
	if match_state.players.values().all(func(player): return player.ended_turn):
	#if player2.type == Player.Type.NPC:
	#	simulate_enemy_card()
		match_state.turn_ended = true
		var card_id_list = {}
		for id in match_state.players:
			var player = match_state.players.get(id)
			card_id_list[id] = player.active_cards

		end_turn()
		match_state.turn_ended=false

# server
func end_turn():
	match_state.reveal_enemy_active_cards()

	await get_tree().create_timer(3.0).timeout

	resolve_cards()

	for player in match_state.players.values():
		player.ended_turn = false
		draw_cards(player.id)
		match_state.players.get(player.id).mana+=1
	for player in match_state.players.values():
		match_state.sync_public_data(player.id)
	print("turn ended")

func draw_cards(player_id, n=1):
	card_manager.draw(match_state.players.get(player_id), n)

@rpc("any_peer","reliable")
func request_play_card(card_id):
	var caller = match_state.players.get(multiplayer.get_remote_sender_id()) 
	var card = card_manager.card_db.get(card_id)

	if caller.mana >= card.cost and caller.hand.any(func(card): return card.id == card_id):
		caller.mana-=card.cost
		caller.active_cards.append(card)

		for hand_card in caller.hand:
			if hand_card.id == card_id:
				caller.hand.erase(hand_card)
				break
	match_state.sync_without_enemy_mana(caller.id)

func simulate_enemy_card():
	#var card = player2.hand.pick_random()
	#request_play_card(player2, card)
	return

func resolve_cards():
	for id in match_state.players:
		for card in match_state.players.get(id).active_cards:
			resolve_card(card ,match_state.players[id])
			card.used.emit()
	for player in match_state.players.values():
		player.active_cards.clear()

func resolve_card(card, own_player):
	if card.blockable and match_state.get_enemy_of(own_player).active_cards.any(func(_card): return card.blocks):
		return
	if card.risky and match_state.get_enemy_of(own_player).active_cards.any(func(_card): return  card.blockable):
		return
	card.effect.call(own_player,match_state.get_enemy_of(own_player), card.number, card.number2)
