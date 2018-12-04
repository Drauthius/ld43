extends TextureRect

signal sacrifice

var Gear = preload("res://scripts/Gear.gd")

var ICONS = {
	Gear.TIER_NORMAL: [preload("res://assets/images/Basic Sword 1.png"), preload("res://assets/images/Basic Sword 2.png")],
	Gear.TIER_MAGIC: [preload("res://assets/images/Magic Sword 1.png"), preload("res://assets/images/Magic Sword 2.png")],
	Gear.TIER_RARE: [preload("res://assets/images/Rare Sword 1.png"), preload("res://assets/images/Rare Sword 2.png")],
	Gear.TIER_LEGENDARY: [preload("res://assets/images/Legendary Sword 1.png"), preload("res://assets/images/Legendary Sword 2.png")]
}

var tier_name = {
	Gear.TIER_NORMAL: "Common",
	Gear.TIER_MAGIC: "Magic",
	Gear.TIER_RARE: "Rare",
	Gear.TIER_LEGENDARY: "Legendary"
}

onready var header = $"MarginContainer/VBoxContainer/Header"
onready var icon = $"MarginContainer/VBoxContainer/Icon"
onready var xp_bar = $"MarginContainer/VBoxContainer/XPBar"
onready var level = $"MarginContainer/VBoxContainer/Level"
onready var description = $"MarginContainer/VBoxContainer/Description"
onready var button = $"MarginContainer/VBoxContainer/Button"
onready var tween = $Tween

var gear
var final_xp

func set_header(text):
	header.text = text

func fill(gear):
	self.gear = gear
	
	if not gear.icon:
		gear.icon = get_icon(gear.tier)
	
	set_icon(gear.icon)
	
	update_xp_bar(gear)
	update_level_text(gear)
	update_description_text(gear)

func fill_hidden(gear):
	self.gear = gear
	
	if not gear.icon:
		gear.icon = get_icon(gear.tier)
	
	set_icon(gear.icon)
	
	update_level_text(gear, true)
	update_description_text(gear, true)

func gain_xp(xp):
	if xp > 0 and gear.level != gear.max_level:
		final_xp = gear.total_xp + xp
		# Only called once?
		#tween.interpolate_method(gear, "set_xp", gear.total_xp, gear.total_xp + xp, xp / 40, Tween.TRANS_LINEAR, Tween.EASE_IN)
		#tween.connect("tween_step", self, "_on_XPBar_tween_step")
		tween.interpolate_method(self, "update_xp", gear.total_xp, final_xp, min(xp / 250.0, 3.0), Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func reveal():
	fill(gear)

func hide_button():
	button.hide()

func update_button():
	button.text = "Continue"

func _on_Sacrifice_button_up():
	if final_xp and gear.total_xp != final_xp:
		gear.set_xp(final_xp)
	emit_signal("sacrifice")

func get_icon(tier):
	var textures = ICONS[tier]
	var texture = textures[randi() % textures.size()]
	icon.set_texture(texture)
	return texture

func set_icon(texture):
	icon.set_texture(texture)

func update_xp(xp):
	var level_before = gear.level
	gear.set_xp(xp)
	update_xp_bar(gear)
	if gear.level != level_before:
		update_level_text(gear)
		update_description_text(gear)

func update_xp_bar(gear):
	xp_bar.max_value = gear.xp_to_level
	xp_bar.value = gear.xp_this_level

func update_level_text(gear, hidden = false):
	if gear.tier != -1:
		level.text = "[" + tier_name[gear.tier] + "] "
	else:
		level.text = "[Basic] "
	
	if hidden:
		level.text += "Level ???"
	else:
		level.text +=  "Level %d" % gear.level
		if gear.level == gear.max_level:
			level.text += " (MAX)"

func update_description_text(gear, hidden = false):
	description.text = ""
	if gear is Gear.Weapon:
		if hidden:
			description.text += "??? - ??? damage"
		else:
			description.text += "%d - %d damage" % [gear.attack_damage[0], gear.attack_damage[1]]
	
	if hidden:
		for property in gear.properties:
			description.text += "\n???"
	else:
		if gear.health > 0:
			description.text += "\n+%d health" % gear.health
		if gear.critical_hit_chance > 0:
			description.text += "\n+%d%% chance to crit" % gear.critical_hit_chance
		if gear.lph > 0:
			description.text += "\n+%d life per hit" % gear.lph

#func _on_XPBar_tween_step(object, key, elapsed, value):
#	xp_bar.value = gear.xp_this_level
#	xp_bar.max_value = gear.xp_to_level