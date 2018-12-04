extends TextureRect

onready var SoundService = $"/root/SoundService"

func _ready():
	SoundService.main_menu()
	pass # Set up sound here

func _on_Start_button_up():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Quit_button_up():
	get_tree().quit()