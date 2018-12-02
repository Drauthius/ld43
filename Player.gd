extends "res://Character.gd"

var Gear = preload("res://Gear.gd")

var weapon

#func _input_event(camera, event, click_position, click_normal, shape_idx):
	#_on_Ground_input_event(camera, event, click_position, click_normal, shape_idx)

func equip(gear):
	if gear is Gear.Weapon:
		if weapon != gear:
			if weapon != null:
				decrease_maximum_health(weapon.health)
			increase_maximum_health(gear.health)
		
		weapon = gear
		attack_damage = weapon.attack_damage

func move_to(position):
	if is_dead or attack_state == ATTACK_PERFORM:
		return # Busy
		
	target = null
	target_position = position
	is_attacking = false
	is_moving = true
	attack_state = null
	timer.stop()

func attack_monster(monster):
	if is_dead or attack_state == ATTACK_PERFORM:
		return # Busy
	if target and target.get_ref() == monster:
		return # Already the current target
	
	target = weakref(monster)
	target_position = null
	is_attacking = true
	is_moving = true
	attack_state = null
	timer.stop()

func handle_attack():
	if is_dead:
		return
	
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
				target.get_ref().on_damage_taken(randf() * (attack_damage[1] - attack_damage[0]) + attack_damage[0])
			# TOOD: Start animation
			timer.set_wait_time(0.5)
			timer.start()
			attack_state = ATTACK_END
			
			if weapon.lph:
				increase_health(weapon.lph)
		ATTACK_END:
			attack_state = null

func die():
	if is_dead:
		return
	
	target = null
	target_position = null
	is_moving = false
	is_attacking = false
	attack_state = null
	timer.stop()
	
	emit_signal("death", self)