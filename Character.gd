extends KinematicBody

const GRAVITY = -1

export (int, 1, 1000) var health = 100
export (int, 1, 1000) var move_speed = 200
export (Vector2) var attack_damage = Vector2(10, 20)
export (int, 1, 100) var attack_range_squared = 2
export (float, 0.1, 100.0) var attack_speed = 1.0

onready var current_health = health
var target = null
var target_position = null
var is_attacking = false
var is_moving = false
var is_dead = false

enum {ATTACK_START, ATTACK_PERFORM, ATTACK_CONTACT, ATTACK_END}
var attack_state = null

onready var timer = $Timer
onready var camera = $"../Player/Camera"
onready var health_bar_pos = $HealthBarPosition
onready var health_bar = $"HealthBarPosition/HealthBar"

func _ready():
	timer.connect("timeout", self, "handle_attack")
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
		if not target.get_ref():
			target = null
			target_position = null
		else:
			target_position = target.get_ref().get_global_transform().origin

func process_movement(delta):
	if not is_moving or target_position == null:
		return

	var vel = target_position - get_global_transform().origin
	vel.y = 0
	if vel.length_squared() < 0.01:
		target = null
		target_position = null
		return
	
	vel.y = GRAVITY
	vel = vel.normalized() * move_speed * delta;
	move_and_slide(vel)

func process_attack(delta):
	if not is_attacking or target == null:
		return
	
	if get_global_transform().origin.distance_squared_to(target_position) < attack_range_squared:
		if attack_state == null or attack_state == ATTACK_END:
			attack_state = ATTACK_START
			handle_attack()
		is_moving = false

func on_damage_taken(amount):
	health_bar.show()
	print("HIT! ", amount)
	current_health -= amount
	health_bar.value = current_health
	if current_health <= 0:
		print("death")
		is_dead = true
		die()

func die():
	queue_free()