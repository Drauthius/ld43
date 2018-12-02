extends TextureRect

signal sacrifice

onready var button = $"MarginContainer/VBoxContainer/Button"

func hide_button():
	button.hide()

func _on_Sacrifice_button_up():
	emit_signal("sacrifice")