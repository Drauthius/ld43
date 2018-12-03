extends Node

onready var SoundService = $"/root/SoundService"


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if (Input.is_key_pressed(KEY_UP)):
		SoundService.stop_all_music()
		SoundService.drum_01_main_menu()
		pass
	if (Input.is_key_pressed(KEY_DOWN)):
		SoundService.stop_all_music()
		pass
	if (Input.is_key_pressed(KEY_RIGHT)):
		SoundService.drum_02_start_battle()
		pass
	pass
