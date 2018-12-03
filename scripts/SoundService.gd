extends Node

var sounds = {
	drum_01_main_menu: AudioStreamPlayer.new(),
	drum_02_start_battle: AudioStreamPlayer.new(),
	drum_03_survive_x_waves: AudioStreamPlayer.new(),
	drum_04_survive_2x_waves: AudioStreamPlayer.new(),
	flue_01_lohealth: AudioStreamPlayer.new(),
	koto_01_heated_battle: AudioStreamPlayer.new()
}

var current_bg_music
var next_bg_music = null

func _ready():
	sounds.drum_01_main_menu.stream = preload("res://assets/sounds/music/drums 01 - menu.wav")
	sounds.drum_02_start_battle.stream = preload("res://assets/sounds/music/drums 02 - start battle.wav")
	sounds.drum_03_survive_x_waves.stream = preload("res://assets/sounds/music/drums 03 - survive x waves.wav")
	sounds.drum_04_survive_2x_waves.stream = preload("res://assets/sounds/music/drums 04 - survive 2x waves.wav")
	sounds.flue_01_lohealth.stream = preload("res://assets/sounds/music/flute 01 - low health.wav")
	sounds.koto_01_heated_battle.stream = preload("res://assets/sounds/music/koto 01 - heated battle.wav")
	
	for sound in sounds:
		add_child(sound)
		sound.connect("finished", self, "_on_sound_finished")
	
	#something
#	physics_start_player.stream = preload("res://music/physics_start.wav")

func stop_all_music():
	drum_01_main_menu.stop()
	drum_02_start_battle.stop()
	drum_03_survive_x_waves.stop()
	drum_04_survive_2x_waves.stop()
	flue_01_lohealth.stop()
	koto_01_heated_battle.stop()
	

func _on_sound_finished():
	pass


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