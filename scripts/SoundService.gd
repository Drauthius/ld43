extends Node

var loops = {
	"drum_01_main_menu": AudioStreamPlayer.new(),
	"drum_02_start_battle": AudioStreamPlayer.new(),
	"drum_03_survive_x_waves": AudioStreamPlayer.new(),
	"drum_04_survive_2x_waves": AudioStreamPlayer.new(),
	"flue_01_lohealth": AudioStreamPlayer.new(),
	"koto_01_heated_battle": AudioStreamPlayer.new()
}

var current_bg_music
var next_bg_music = null

var current_loops = {
	"drum": null,
	"koto": null,
	"flute": null
	
}

func _ready():
	loops.drum_01_main_menu.stream = preload("res://assets/sounds/music/drums 01 - menu.wav")
	loops.drum_02_start_battle.stream = preload("res://assets/sounds/music/drums 02 - start battle.wav")
	loops.drum_03_survive_x_waves.stream = preload("res://assets/sounds/music/drums 03 - survive x waves.wav")
	loops.drum_04_survive_2x_waves.stream = preload("res://assets/sounds/music/drums 04 - survive 2x waves.wav")
	loops.flue_01_lohealth.stream = preload("res://assets/sounds/music/flute 01 - low health.wav")
	loops.koto_01_heated_battle.stream = preload("res://assets/sounds/music/koto 01 - heated battle.wav")
	
	for key in loops:
		add_child(loops[key])
		loops[key].connect("finished", self, "_on_sound_finished")
	
	#something
#	physics_start_player.stream = preload("res://music/physics_start.wav")

func stop_all_music():
	for key in loops:
		loops[key].stop()

func _on_sound_finished():
	if(next_bg_music != null):
		current_bg_music = next_bg_music
	current_bg_music.play()
	pass

func play_or_queue(loop):
	if current_bg_music == null:
		current_bg_music = loop
		return null
	next_bg_music = loop

func drum_01_main_menu():
	play_or_queue(loops.drum_01_main_menu)

func drum_02_start_battle():
	play_or_queue(loops.drum_02_start_battle)

func drum_03_survive_x_waves():
	play_or_queue(loops.drum_03_survive_x_waves)

func drum_04_survive_2x_waves():
	play_or_queue(loops.drum_04_survive_2x_waves)

func flue_01_lohealth():
	play_or_queue(loops.flue_01_lohealth)

func koto_01_heated_battle():
	play_or_queue(loops.koto_01_heated_battle)