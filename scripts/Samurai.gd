extends Spatial

signal attack_performed
signal attack_contact(area)
signal attack_end

onready var animation_player = $AnimationPlayer
onready var hit_area = $Skeleton/HitArea

func _ready():
	idle()

func attack():
	animation_player.play("Attack")

func run():
	#animation_player.play("Run")
	idle()

func idle():
	animation_player.play("Attack")
	animation_player.seek(0.0, true)
	animation_player.stop()

func die():
	idle()

func _on_attack_perform():
	emit_signal("attack_performed")

func _on_attack_contact():
	emit_signal("attack_contact", hit_area)

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("attack_end")
	idle()