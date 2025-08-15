extends Control

func set_error_message(message: String):
	$ErrorLabel.text = message
	$ErrorLabel.visible = true
