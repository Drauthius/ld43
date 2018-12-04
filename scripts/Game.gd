extends Spatial

var Monster = preload("res://scenes/Monster.tscn")
var GameOver = preload("res://scenes/GameOver.tscn")
var EndGame = preload("res://scenes/EndGame.tscn")
var GearChoice = preload("res://scenes/GearChoice.tscn")
var Gear = preload("res://scripts/Gear.gd")
onready var SoundService = $"/root/SoundService"

onready var player = $Player
onready var spawn_points = $SpawnPoints.get_children()

var monsters_left = 0
var monsters_alive = 0

var stage = 0
var stages = [ 1, 2, 3, 3, 4, 5 ]
var stage_xp = 0
var stage_growth = {
	"xp": 150,
	"health": 2,
	"attack_damage": Vector2(1, 2)
}
var health_per_stage = 15
var health_growth = 3

var is_paused = false
var gear_choice_dialogue = null

func _ready():
	randomize()
	
	player.equip(Gear.Weapon.generate())
	
	new_stage()
	
	SoundService.start_battle()

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
		SoundService.stop_all_music()
		SoundService.endgame()
		add_child(EndGame.instance())
		return
	
	player.increase_health(health_per_stage + health_growth * stage)
	
	var tier
	if stage < 2:
		tier = randi() % 2
	elif stage < 4:
		SoundService.survive_x_waves()
		tier = randi() % 3
	else:
		SoundService.survive_2x_waves()
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
	monster.set_translation(spawn_points[randi() % spawn_points.size()].get_translation() + Vector3(randf() * 2 - 1, 0.0, randf() * 2 - 1))
	
	monster.connect("on_clicked", self, "_on_Monster_clicked")
	monster.connect("death", self, "_on_Monster_death")
	
	monster.upgrade(stage_growth["xp"] * stage, stage_growth["health"] * stage, stage_growth["attack_damage"] * stage)
	monster.hunt(player)
	
	monsters_left -= 1
	monsters_alive += 1

#func retry():
#	get_tree().reload_current_scene()

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
	add_child(GameOver.instance())

func _on_GearChoice_sacrifice_event():
	SoundService.weapon_sacrifice()
	pass

func _on_GearChoice_resume_event(gear):
	stage_xp = 0
	gear_choice_dialogue.queue_free()
	gear_choice_dialogue = null
	is_paused = false
	player.equip(gear)
	new_stage()
