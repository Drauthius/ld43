extends "res://scripts/Character.gd"

var Gear = preload("res://scripts/Gear.gd")

var weapon

func equip(gear):
	if gear is Gear.Weapon:
		if weapon != gear:
			if weapon != null:
				decrease_maximum_health(weapon.health)
				critical_hit_chance -= weapon.critical_hit_chance
			increase_maximum_health(gear.health)
			critical_hit_chance += gear.critical_hit_chance
		
		weapon = gear
		attack_damage = weapon.attack_damage
		life_per_hit = weapon.lph

func move_to(position):
	if is_dead or attack_state == ATTACK_PERFORM:
		return # Busy
	
	$Samurai.run()
	target = null
	target_position = position
	is_attacking = false
	is_moving = true
	attack_state = null

func attack_monster(monster):
	if is_dead or attack_state == ATTACK_PERFORM:
		return # Busy
	if target and target.get_ref() == monster:
		return # Already the current target
	
	$Samurai.run()
	target = weakref(monster)
	target_position = null
	is_attacking = true
	is_moving = true
	attack_state = null

func die():
	if is_dead:
		return
	
	$Samurai.die()
	target = null
	target_position = null
	is_moving = false
	is_attacking = false
	attack_state = null
	#timer.stop()

func _on_Samurai_dead():
	emit_signal("death", self)