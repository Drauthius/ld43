extends "res://Character.gd"

var Gear = preload("res://Gear.gd")

onready var weapon = Gear.Weapon.new()

func _ready():
	weapon.level = 1
	weapon.max_level = 1
	weapon.xp = 0
	weapon.attack_damage = Vector2(8, 12)

#func _input_event(camera, event, click_position, click_normal, shape_idx):
	#_on_Ground_input_event(camera, event, click_position, click_normal, shape_idx)

func _on_Ground_input_event(camera, event, click_position, click_normal, shape_idx):
	if is_dead:
		return
	if attack_state == ATTACK_PERFORM:
		return
	
	if Input.is_mouse_button_pressed(1):
		target = null
		target_position = click_position
		is_attacking = false
		is_moving = true
		attack_state = null
		timer.stop()

func _on_Monster_clicked(monster):
	if is_dead:
		return
	if target and target.get_ref() == monster:
		return
	if attack_state == ATTACK_PERFORM:
		return
	
	target = weakref(monster)
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
				target.get_ref().on_damage_taken(randi() % int(attack_damage[1] - attack_damage[0]) + int(attack_damage[0]))
			# TOOD: Start animation
			timer.set_wait_time(0.5)
			timer.start()
			attack_state = ATTACK_END
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