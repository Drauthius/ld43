extends TextureRect

onready var tween = $Tween

func _ready():
	var pos = rect_global_position
	# Update position directly, to avoid one frame of the old value.
	rect_global_position = Vector2(0, -rect_size.y)
	tween.interpolate_property(self, "rect_global_position", Vector2(0, -rect_size.y), pos, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Restart_button_up():
	get_tree().change_scene("res://scenes/Game.tscn")