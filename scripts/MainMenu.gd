extends TextureRect

func _ready():
	pass # Set up sound here

func _on_Start_button_up():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Quit_button_up():
	get_tree().quit()