extends Node

var loops = {
	"drum_01_main_menu": AudioStreamPlayer.new(),
	"drum_02_start_battle": AudioStreamPlayer.new(),
	"drum_03_survive_x_waves": AudioStreamPlayer.new(),
	"drum_04_survive_2x_waves": AudioStreamPlayer.new(),
	"flute_01_lohealth": AudioStreamPlayer.new(),
	"koto_01_heated_battle": AudioStreamPlayer.new()
}

var sfx = {
	"death_scene_transition": AudioStreamPlayer.new(),
	"weapon_sacrifice": AudioStreamPlayer.new()
}


var current_bg_music = {
	"drums": null,
	"koto": null,
	"flute": null
}

var next_bg_music = {
	"drums": null,
	"koto": null,
	"flute": null
}

func _ready():
	loops.drum_01_main_menu.stream = preload("res://assets/sounds/music/drums 01 - menu.wav")
	loops.drum_02_start_battle.stream = preload("res://assets/sounds/music/drums 02 - start battle.wav")
	loops.drum_03_survive_x_waves.stream = preload("res://assets/sounds/music/drums 03 - survive x waves.wav")
	loops.drum_04_survive_2x_waves.stream = preload("res://assets/sounds/music/drums 04 - survive 2x waves.wav")
	loops.flute_01_lohealth.stream = preload("res://assets/sounds/music/flute 01 - low health.wav")
	loops.koto_01_heated_battle.stream = preload("res://assets/sounds/music/koto 01 - heated battle.wav")
	
	sfx.death_scene_transition = preload("res://assets/sounds/sfx/death scene transition drums.wav")
	sfx.weapon_sacrifice = preload("res://assets/sounds/sfx/weapon sacrifice.wav")
	
	for key in loops:
		add_child(loops[key])
		loops[key].connect("finished", self, "_on_sound_finished")
		
	for key in sfx:
		add_child(sfx[key])
	
	#something
#	physics_start_player.stream = preload("res://music/physics_start.wav")

func stop_all_music():
	for key in loops:
		if loops[key] != null:
			loops[key].stop()
	for key in current_bg_music:
		current_bg_music[key] = null
		next_bg_music[key] = null

func _on_sound_finished():
	for key in next_bg_music:
		if next_bg_music[key] != null:
			current_bg_music[key] = next_bg_music[key]
	for key in current_bg_music:
		if current_bg_music[key] != null:
			current_bg_music[key].play()
#	if(next_bg_music != null):
#		current_bg_music = next_bg_music
#	current_bg_music.play()
	pass

func play_or_queue(loops):
	var all_are_null = true
	var at_least_one_is_null = false
	for key in loops:
		if current_bg_music[key] == null:
			current_bg_music[key] = loops[key]
			at_least_one_is_null = true
		else:
			all_are_null = false
	print("all_are_null ", all_are_null, "; at_least_one_is_null ", at_least_one_is_null)
	if all_are_null:
		for key in current_bg_music:
			if current_bg_music[key] != null:
				current_bg_music[key].play()
	elif at_least_one_is_null:
		pass
	for key in loops:
		next_bg_music[key] = loops[key]

func main_menu():
	var loopses = {
		"drums":loops.drum_01_main_menu,
		"koto": null,
		"flute": null
		}
	play_or_queue(loopses)

func start_battle():
	var loopses = {
		"drums":loops.drum_02_start_battle,
		"koto": null,
		"flute": null
		}
	play_or_queue(loopses)

func survive_x_waves():
	var loopses = {
		"drums":loops.drum_03_survive_x_waves,
		"koto": loops.koto_01_heated_battle,
		"flute": null
		}
	play_or_queue(loopses)

func survive_2x_waves():
	var loopses = {
		"drums":loops.drum_04_survive_2x_waves,
		"koto": loops.koto_01_heated_battle,
		"flute": loops.flute_01_lohealth
		}
	play_or_queue(loopses)

func death_scene_transition():
	sfx.death_scene_transition.play()
	pass

func weapon_sacrifice():
	sfx.weapon_sacrifice.play()
	pass