extends KinematicBody

const GRAVITY = -1

export (int, 1, 1000) var health = 100
export (int, 1, 1000) var move_speed = 200
export (Vector2) var attack_damage = Vector2(10, 20)
export (int, 1, 100) var attack_range_squared = 2
export (float, 0.1, 100.0) var attack_speed = 1.0
export (int, 0, 100) var critical_hit_chance = 0
export (int, 0, 100) var life_per_hit = 0


onready var current_health = health
var target = null
var target_position = null
var is_attacking = false
var is_moving = false
var is_dead = false

enum {ATTACK_START, ATTACK_PERFORM, ATTACK_CONTACT, ATTACK_END}
var attack_state = null

onready var camera = $"../Player/Camera"
onready var health_bar_pos = $HealthBarPosition
onready var health_bar = $"HealthBarPosition/HealthBar"

onready var samurai = $Samurai

onready var SoundService = $"/root/SoundService"

signal death(node)

func _ready():
	health_bar.value = health
	health_bar.max_value = health
	health_bar.hide()

func _process(delta):
	var pos = camera.unproject_position(health_bar_pos.get_global_transform().origin)
	health_bar.set_position(Vector2(pos.x - health_bar.rect_size.x / 2, pos.y))

func _physics_process(delta):
	update_target()
	process_attack(delta)
	process_movement(delta)

func update_target():
	if target != null:
		if not target.get_ref() or target.get_ref().is_dead:
			target = null
			target_position = null
		else:
			target_position = target.get_ref().get_global_transform().origin

func process_movement(delta):
	if is_dead or not is_moving or target_position == null:
		return
	
	samurai.run()
	
	var vel = target_position - get_global_transform().origin
	vel.y = 0
	if vel.length_squared() < 0.1:
		target = null
		target_position = null
		samurai.idle()
		return
	
	vel.y = GRAVITY
	vel = vel.normalized() * move_speed * delta;
	var remaining = move_and_slide(vel, Vector3(0, 1, 0))
	if self.name == "Player" and remaining.length_squared() < 1.5:
		target = null
		target_position = null
		samurai.idle()
		return
	
	samurai.look_at(target_position, Vector3(0, 1, 0))
	samurai.rotate_y(deg2rad(180))

func process_attack(delta):
	if is_dead or not is_attacking or target == null:
		return
	
	if get_global_transform().origin.distance_squared_to(target_position) < attack_range_squared:
		if attack_state != ATTACK_PERFORM or attack_state != ATTACK_END:
			samurai.look_at(target_position, Vector3(0, 1, 0))
			samurai.rotate_y(deg2rad(180))
			
		if attack_state == null or attack_state == ATTACK_END:
			attack_state = ATTACK_START
			handle_attack()
		is_moving = false

func handle_attack():
	if is_dead:
		return
	
	match attack_state:
		ATTACK_START:
			samurai.attack()

func update_health(amount):
	current_health = min(current_health + amount, health)
	
	health_bar.value = ceil(current_health)
	health_bar.visible = current_health != health

func on_damage_taken(amount):
	if is_dead:
		return
	
	print(self.name, " got HIT for ", amount, "! ", current_health - amount, "/", health, " left")
	update_health(-amount)
	
	if current_health <= 0:
		print(self.name, " death")
		die()
		is_dead = true

func die():
	if is_dead:
		return
	
	$CollisionShape.disabled = true
	health_bar.hide()
	samurai.die()
	emit_signal("death", self)

func increase_health(amount):
	print(self.name, " got HEAL for ", amount, "! ", current_health + amount, "/", health, " left")
	update_health(amount)

func increase_maximum_health(amount):
	print(self.name, " health UP by ", amount, "! ", current_health + amount, "/", health + amount, " left")
	health += amount
	health_bar.max_value = health
	update_health(amount)

func decrease_maximum_health(amount):
	print(self.name, " health DOWN by ", amount, "! ", current_health, "/", health - amount, " left")
	health -= amount
	health_bar.max_value = health
	update_health(0)

func _on_Samurai_attack_performed():
	attack_state = ATTACK_PERFORM # No backing away now
	handle_attack()

func _on_Samurai_attack_contact(area):
	attack_state = ATTACK_CONTACT
	if target and target.get_ref() and area.overlaps_body(target.get_ref()):
		var damage = randf() * (attack_damage[1] - attack_damage[0]) + attack_damage[0]
		if critical_hit_chance > 0 and randf() < critical_hit_chance / 100.0:
			print("CRIT")
			damage *= 1.5
			SoundService.weapon_crit()
		else:
			SoundService.weapon_hit()
		target.get_ref().on_damage_taken(damage)
		
		if life_per_hit > 0:
			increase_health(life_per_hit)
	handle_attack()

func _on_Samurai_attack_end():
	attack_state = ATTACK_END # Done attacking
	handle_attack()

func _on_Samurai_dead():
	queue_free()