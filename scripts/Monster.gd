extends "res://scripts/Character.gd"

export (int, 0, 1000) var xp_worth = 35

signal on_clicked

var player

func _ready():
	player = $"../Player"
	target = weakref(player)
	is_moving = true
	is_attacking = true

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		emit_signal("on_clicked", self)

func handle_attack():
	match attack_state:
		ATTACK_START:
			# TOOD: Start animation
			timer.set_wait_time(0.5)
			timer.start()
			attack_state = ATTACK_PERFORM
		ATTACK_PERFORM:
			# TOOD: Start animation
			timer.set_wait_time(0.5)
			timer.start()
			attack_state = ATTACK_CONTACT
		ATTACK_CONTACT:
			if target and target.get_ref():
				target.get_ref().on_damage_taken(randi() % int(attack_damage[1] - attack_damage[0]) + int(attack_damage[0]))
			# TOOD: Start animation
			timer.set_wait_time(0.5)
			timer.start()
			attack_state = ATTACK_END
		ATTACK_END:
			attack_state = null
			is_moving = true