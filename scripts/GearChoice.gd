extends MarginContainer

var Vanished = preload("res://scenes/Vanished.tscn")

signal sacrifice
signal resume(gear)

onready var current_gear = $"VBoxContainer/HBoxContainer/CurrentGear"
onready var new_gear = $"VBoxContainer/HBoxContainer/NewGear"
onready var tween = $Tween

var sacrificed = false
var xp = 0

func _ready():
	var pos = self.rect_global_position
	# Update position directly, to avoid one frame of the old value.
	rect_global_position = Vector2(0, -self.rect_size.y)
	tween.interpolate_property(self, "rect_global_position", Vector2(0, -self.rect_size.y), pos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	current_gear.set_header("Current")
	new_gear.set_header("New")

func set_gear(gear, xp, new):
	self.xp = xp
	current_gear.fill(gear)
	new_gear.fill_hidden(new)

func _on_CurrentGear_sacrifice():
	sacrifice(current_gear, new_gear)
	new_gear.reveal()
	
	var pos = new_gear.rect_global_position - Vector2(current_gear.rect_size.x / 2, 0)
	tween.interpolate_property(new_gear, "rect_global_position", new_gear.rect_global_position, pos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_NewGear_sacrifice():
	sacrifice(new_gear, current_gear)
	
	var pos = current_gear.rect_global_position + Vector2(new_gear.rect_size.x / 2, 0)
	tween.interpolate_property(current_gear, "rect_global_position", current_gear.rect_global_position, pos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func sacrifice(card, other):
	if sacrificed:
		emit_signal("resume", card.gear)
		return
	
	other.update_button()
	card.hide_button()
	card.modulate = Color(0, 0, 0, 0)
	var particles = Vanished.instance()
	card.get_parent().add_child(particles)
	particles.set_position(card.get_global_position() + card.get_size() / Vector2(2, 2))
	particles.emitting = true
	particles.one_shot = true
	sacrificed = true
	emit_signal("sacrifice")

func _on_Tween_tween_completed(object, key):
	if not sacrificed:
		current_gear.gain_xp(xp)