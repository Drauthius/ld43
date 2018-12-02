extends Spatial

var Monster = preload("res://Monster.tscn")
var GameOver = preload("res://GameOver.tscn")

onready var player = $Player
onready var spawn_points = $SpawnPoints.get_children()

var monsters_left = 0
var monsters_alive = 0

var stage = 0
var stages = [ 1, 2, 2 ]
var stage_xp = 0

func _ready():
	randomize()
	new_stage()

func new_stage():
	if stage >= stages.size():
		#player.is_dead = true
		#_on_Player_death()
		player.die()
		return
	
	if stage != 0:
		print("NEW STAGE ", stage)
	
	#player.award_xp(stage_xp)
	
	monsters_left = stages[stage]
	while monsters_left > 0:
		spawn_monster()
	
	stage_xp = 0
	stage += 1

func spawn_monster():
	var monster = Monster.instance()
	monster.set_translation(spawn_points[randi() % spawn_points.size()].get_translation())
	add_child(monster)
	monster.connect("on_clicked", player, "_on_Monster_clicked")
	monster.connect("death", self, "_on_Monster_death")
	
	monsters_left -= 1
	monsters_alive += 1

func _on_Monster_death(monster):
	stage_xp += monster.xp_worth
	monsters_alive -= 1
	if monsters_left == 0 and monsters_alive == 0:
		new_stage()

func _on_Player_death():
	var game_over = GameOver.instance()
	add_child(game_over)
	game_over.connect("retry", self, "_on_retry")

func _on_retry():
	get_tree().reload_current_scene()
