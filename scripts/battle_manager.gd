extends Node

signal card_played

var player1 = Player.new(Player.Type.HUMAN)
var player2 = Player.new(Player.Type.NPC)
var players = [player1, player2]
var current_player = player1
var not_current_player = player2

@rpc("any_peer","call_local","reliable")
func end_turn():
	print("i am "+ str(multiplayer.get_unique_id()))
	var player
	if multiplayer.get_unique_id() == multiplayer.get_remote_sender_id():
		player=player1
	else:
		player= player2
	player.turn_ended=true

	if player1.turn_ended and player2.turn_ended:
	#if player2.type == Player.Type.NPC:
	#	simulate_enemy_card()

		for card in player2.active_cards:
			card.played.emit()
			card_played.emit(card, false)
		await get_tree().create_timer(3.0).timeout

		resolve_cards()
		get_turn_end_ressources()

func get_turn_end_ressources():
	player1.current_mana+=1
	CardManager.draw(player1)
	for player in players:
		player.turn_ended=false

@rpc("any_peer","call_local","reliable")
func play_card(player, card):

	if multiplayer.has_multiplayer_peer():
		card = CardManager.get_card_by_instance_id(card)

	print(player1.id)
	if multiplayer.get_unique_id() == multiplayer.get_remote_sender_id():
		player=player1
		card.played.emit()
		card_played.emit(card, true)
	else:
		player= player2

	print(card)
	if player.current_mana < card.cost :
		return

	player.current_mana-=card.cost
	player.active_cards.append(card)

func simulate_enemy_card():
	var card = player2.hand.pick_random()
	play_card(player2, card)

func resolve_cards():
	for card in player1.active_cards:
		resolve_card(card,player1,player2)
		card.used.emit()
	for card in player2.active_cards:
		resolve_card(card,player2,player1)
		card.used.emit()
	for player in players:
		player.active_cards.clear()

func resolve_card(card, own_player, opposing_player):
	if card.blockable and opposing_player.active_card.any(func(_card): card.blocks):
		return
	card.effect.call(own_player,opposing_player, card.number, card.number2)
