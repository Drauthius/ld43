extends MarginContainer

var Vanished = preload("res://scenes/Vanished.tscn")

signal sacrifice

onready var current_gear = $"VBoxContainer/HBoxContainer/CurrentGear"
onready var new_gear = $"VBoxContainer/HBoxContainer/NewGear"

func _on_CurrentGear_sacrifice():
	new_gear.hide_button()
	sacrifice(current_gear)

func _on_NewGear_sacrifice():
	current_gear.hide_button()
	sacrifice(new_gear)

func sacrifice(card):
	card.hide_button()
	card.modulate = Color(0, 0, 0, 0)
	var particles = Vanished.instance()
	card.get_parent().add_child(particles)
	particles.set_position(card.get_global_position() + card.get_size() / Vector2(2, 2))
	particles.emitting = true
	particles.one_shot = true