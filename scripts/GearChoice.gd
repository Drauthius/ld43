extends MarginContainer

var Vanished = preload("res://scenes/Vanished.tscn")

signal sacrifice
signal resume

onready var current_gear = $"VBoxContainer/HBoxContainer/CurrentGear"
onready var new_gear = $"VBoxContainer/HBoxContainer/NewGear"

var sacrificed = false

var Gear = preload("res://Gear.gd")
func _ready():
	randomize()
	var weapon = Gear.Weapon.new()
	weapon.max_level = 2
	weapon.xp_to_level = 100
	weapon.attack_damage = Vector2(4, 6)
	weapon.attack_damage_growth = Vector2(0.5, 1)
	weapon.set_xp(10)
	current_gear.fill(weapon, 100)
	new_gear.fill_hidden(Gear.Weapon.generate(Gear.TIER_MAGIC))

func _on_CurrentGear_sacrifice():
	new_gear.update_button()
	sacrifice(current_gear)
	new_gear.reveal()

func _on_NewGear_sacrifice():
	current_gear.update_button()
	sacrifice(new_gear)

func sacrifice(card):
	if sacrificed:
		emit_signal("resume")
		return
	
	card.hide_button()
	card.modulate = Color(0, 0, 0, 0)
	var particles = Vanished.instance()
	card.get_parent().add_child(particles)
	particles.set_position(card.get_global_position() + card.get_size() / Vector2(2, 2))
	particles.emitting = true
	particles.one_shot = true
	sacrificed = true
	emit_signal("sacrifice")