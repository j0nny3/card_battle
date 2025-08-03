extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var name
	name = get_parent().get_node("NameEdit").text
	if not name :
		name =get_parent().get_node("NameEdit").placeholder_text 
	NetworkManager.player_info["name"] = name
	NetworkManager.join_game()
