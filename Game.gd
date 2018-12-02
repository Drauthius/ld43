extends Spatial

var Monster = preload("res://Monster.tscn")
var GameOver = preload("res://GameOver.tscn")
var GearChoice = preload("res://GearChoice.tscn")
var Gear = preload("res://Gear.gd")

onready var player = $Player
onready var spawn_points = $SpawnPoints.get_children()

var monsters_left = 0
var monsters_alive = 0

var stage = 0
var stages = [ 1, 2, 3, 4 ]
var stage_xp = 0

var is_paused = false
var gear_choice_dialogue = null

func _ready():
	randomize()
	
	player.equip(Gear.Weapon.generate())
	
	new_stage()

func new_stage():
	if stage != 0:
		print("NEW STAGE ", stage)
	
	monsters_left = stages[stage]
	while monsters_left > 0:
		spawn_monster()
	
	stage += 1

func stage_completed():
	is_paused = true
	
	if stage >= stages.size():
		print("Weiner!")
		player.die()
		return
	
	var tier
	if stage < 2:
		tier = randi() % 2
	elif stage < 4:
		tier = randi() % 3
	else:
		tier = randi() % Gear.Tiers.size()
	
	gear_choice_dialogue = GearChoice.instance()
	add_child(gear_choice_dialogue)
	gear_choice_dialogue.set_gear(player.weapon, stage_xp, Gear.Weapon.generate(tier))
	
	gear_choice_dialogue.connect("sacrifice", self, "_on_GearChoice_sacrifice_event")
	gear_choice_dialogue.connect("resume", self, "_on_GearChoice_resume_event")

func spawn_monster():
	var monster = Monster.instance()
	add_child(monster)
	
	# Don't place them at the exact same location, or they become one superfast superstrong monster (literally).
	monster.set_translation(spawn_points[randi() % spawn_points.size()].get_translation() + Vector3(randf() - 0.5, 0.0, randf() - 0.5))
	
	monster.connect("on_clicked", self, "_on_Monster_clicked")
	monster.connect("death", self, "_on_Monster_death")
	
	monsters_left -= 1
	monsters_alive += 1

func retry():
	get_tree().reload_current_scene()

func _on_Ground_input_event(camera, event, click_position, click_normal, shape_idx):
	if is_paused:
		return
	
	if Input.is_mouse_button_pressed(1):
		player.move_to(click_position)

func _on_Monster_clicked(monster):
	if is_paused:
		return
	
	player.attack_monster(monster)

func _on_Monster_death(monster):
	stage_xp += monster.xp_worth
	monsters_alive -= 1
	if monsters_left == 0 and monsters_alive == 0:
		stage_completed()

func _on_Player_death(player):
	var game_over = GameOver.instance()
	add_child(game_over)
	game_over.connect("retry", self, "retry")

func _on_GearChoice_sacrifice_event():
	pass

func _on_GearChoice_resume_event(gear):
	stage_xp = 0
	gear_choice_dialogue.queue_free()
	gear_choice_dialogue = null
	is_paused = false
	player.equip(gear)
	new_stage()