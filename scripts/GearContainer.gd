extends TextureRect

signal sacrifice

var Gear = preload("res://Gear.gd")

var ICONS = {
	Gear.TIER_NORMAL: preload("res://assets/images/Basic Katana 1.png"),
	Gear.TIER_MAGIC: preload("res://assets/images/Magic Katana 1.png"),
	Gear.TIER_RARE: preload("res://assets/images/Rare Sword 1.png"),
	Gear.TIER_LEGENDARY: preload("res://assets/images/Legendary Sword 1.png")
}

onready var header = $"MarginContainer/VBoxContainer/Header"
onready var icon = $"MarginContainer/VBoxContainer/Icon"
onready var xp_bar = $"MarginContainer/VBoxContainer/XPBar"
onready var level = $"MarginContainer/VBoxContainer/Level"
onready var description = $"MarginContainer/VBoxContainer/Description"
onready var button = $"MarginContainer/VBoxContainer/Button"
onready var tween = $Tween

var gear

func fill(gear, xp):
	self.gear = gear
	
	set_icon(gear.tier)
	update_xp_bar(gear)
	update_level_text(gear)
	update_description_text(gear)
	
	if xp > 0:
		# Only called once?
		#tween.interpolate_method(gear, "set_xp", gear.total_xp, gear.total_xp + xp, xp / 40, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#tween.connect("tween_step", self, "_on_XPBar_tween_step")
		tween.interpolate_method(self, "update_xp", gear.total_xp, gear.total_xp + xp, xp / 40, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func fill_hidden(gear):
	self.gear = gear
	
	set_icon(gear.tier)
	update_level_text(gear, true)
	update_description_text(gear, true)

func reveal():
	fill(self.gear, 0)

func hide_button():
	button.hide()

func update_button():
	button.text = "Continue"

func _on_Sacrifice_button_up():
	emit_signal("sacrifice")

func set_icon(tier):
	icon.set_texture(ICONS[tier])

func update_xp(xp):
	var level_before = gear.level
	gear.set_xp(xp)
	update_xp_bar(gear)
	if gear.level != level_before:
		update_level_text(gear)
		update_description_text(gear)

func update_xp_bar(gear):
	xp_bar.value = gear.xp_this_level
	xp_bar.max_value = gear.xp_to_level

func update_level_text(gear, hidden = false):
	if hidden:
		level.text = "Level ???"
	else:
		level.text =  "Level %d" % gear.level
		if gear.level == gear.max_level:
			level.text += " (MAX)"

func update_description_text(gear, hidden = false):
	description.text = ""
	if gear is Gear.Weapon:
		if hidden:
			description.text += "\n??? - ??? damage"
		else:
			description.text += "\n%d - %d damage" % [gear.attack_damage[0], gear.attack_damage[1]]
	
	if hidden:
		for property in gear.properties:
			description.text += "\n???"
	else:
		if gear.health > 0:
			description.text += "\n+%d health" % gear.health
		if gear.lph > 0:
			description.text += "\n+%d life per hit" % gear.lph

#func _on_XPBar_tween_step(object, key, elapsed, value):
#	xp_bar.value = gear.xp_this_level
#	xp_bar.max_value = gear.xp_to_level