extends Spatial

var Monster = preload("res://Monster.tscn")
var GameOver = preload("res://GameOver.tscn")

onready var player = $Player
onready var spawn_points = $SpawnPoints.get_children()

func _ready():
	randomize()
	spawn()

func spawn():
	var monster = Monster.instance()
	monster.set_translation(spawn_points[randi() % spawn_points.size()].get_translation())
	add_child(monster)
	monster.connect("on_clicked", player, "_on_Monster_clicked")

func _on_Player_game_over():
	var game_over = GameOver.instance()
	add_child(game_over)
	game_over.connect("retry", self, "_on_retry")

func _on_retry():
	get_tree().reload_current_scene()