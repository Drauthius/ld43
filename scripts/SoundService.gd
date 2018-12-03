extends Node

var drum_01_main_menu = AudioStreamPlayer.new()
var drum_02_start_battle = AudioStreamPlayer.new()
var drum_03_survive_x_waves = AudioStreamPlayer.new()
var drum_04_survive_2x_waves = AudioStreamPlayer.new()
var flue_01_lohealth = AudioStreamPlayer.new()
var koto_01_heated_battle = AudioStreamPlayer.new()

func _ready():
	drum_01_main_menu.stream = preload("res://assets/sounds/music/drums 01 - menu.wav")
	drum_02_start_battle.stream = preload("res://assets/sounds/music/drums 02 - start battle.wav")
	drum_03_survive_x_waves.stream = preload("res://assets/sounds/music/drums 03 - survive x waves.wav")
	drum_04_survive_2x_waves.stream = preload("res://assets/sounds/music/drums 04 - survive 2x waves.wav")
	flue_01_lohealth.stream = preload("res://assets/sounds/music/flute 01 - low health.wav")
	koto_01_heated_battle.stream = preload("res://assets/sounds/music/koto 01 - heated battle.wav")
	
	add_child(drum_01_main_menu)
	add_child(drum_02_start_battle)
	add_child(drum_03_survive_x_waves)
	add_child(drum_04_survive_2x_waves)
	add_child(flue_01_lohealth)
	add_child(koto_01_heated_battle)
	
#	physics_start_player.stream = preload("res://music/physics_start.wav")

func stop_all_music():
	drum_01_main_menu.stop()
	drum_02_start_battle.stop()
	drum_03_survive_x_waves.stop()
	drum_04_survive_2x_waves.stop()
	flue_01_lohealth.stop()
	koto_01_heated_battle.stop()

func drum_01_main_menu():
	drum_01_main_menu.play()

func drum_02_start_battle():
	drum_02_start_battle.play()

func drum_03_survive_x_waves():
	drum_03_survive_x_waves.play()

func drum_04_survive_2x_waves():
	drum_04_survive_2x_waves.play()

func flue_01_lohealth():
	flue_01_lohealth.play()

func koto_01_heated_battle():
	koto_01_heated_battle.play()