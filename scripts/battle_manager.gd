extends Node

signal card_played

var player1 = Player.new(Player.Type.HUMAN)
var player2 = Player.new(Player.Type.NPC)
var players = [player1, player2]
var current_player = player1
var not_current_player = player2

var player_cards: Array[Card]
var enemy_cards: Array[Card]

func end_turn():
	simulate_enemy_card()

	await get_tree().create_timer(3.0).timeout

	resolve_cards()
	get_turn_end_ressources()

func get_turn_end_ressources():
	for player in players:
		player.mana=player.mana+1
		CardManager.draw(player)

func play_card(player, card):
	player.active_cards.append(card)
	card_played.emit(card, player == player1)

func simulate_enemy_card():
	enemy_cards.append(BattleManager.player2.play_random_card())

func resolve_cards():
	for card in player_cards:
		resolve_card(card,player1,player2)
	for card in enemy_cards:
		resolve_card(card,player1,player2)
	player_cards= []
	enemy_cards= []

func resolve_card(card, own_player, opposing_player):
	if card.blockable and opposing_player.active_card.any(func(_card): card.blocks):
		return
	card.effect.call(own_player,opposing_player, card.number)
