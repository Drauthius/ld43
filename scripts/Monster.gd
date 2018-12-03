extends "res://scripts/Character.gd"

export (int, 0, 1000) var xp_worth = 35

signal on_clicked

func hunt(target):
	$Samurai.run()
	self.target = weakref(target)
	is_moving = true
	is_attacking = true

func upgrade(xp, health, damage):
	xp_worth += xp
	attack_damage += damage

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("on_clicked", self)

func handle_attack():
	.handle_attack()
	
	match attack_state:
		ATTACK_END:
			attack_state = null
			is_moving = true
			$Samurai.run()