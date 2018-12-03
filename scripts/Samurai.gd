extends Spatial

signal attack_performed
signal attack_contact(area)
signal attack_end
signal dead

onready var animation_player = $AnimationPlayer
onready var hit_area = $Skeleton/HitArea

var dead = false

func _ready():
	idle()

func attack():
	if animation_player.current_animation != "Attack":
		animation_player.play("Attack")

func run():
	if animation_player.current_animation != "Run":
		animation_player.play("Run")

func idle():
	if animation_player.current_animation != "Idle":
		animation_player.play("Idle")

func die():
	if dead:
		return
	
	animation_player.play("Death")
	dead = true

func _on_attack_perform():
	emit_signal("attack_performed")

func _on_attack_contact():
	emit_signal("attack_contact", hit_area)

func _on_AnimationPlayer_animation_finished(anim_name):
	if dead:
		emit_signal("dead")
		return
	
	emit_signal("attack_end")
	idle()