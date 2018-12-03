extends MarginContainer

signal retry

func _on_Button_button_up():
	emit_signal("retry")