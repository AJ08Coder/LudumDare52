extends "res://Characters/Enemy/Enemy.gd"
onready var hit_box: Area2D = $HitBox

func _process(delta):
	$HitBox.look_at(player.global_position)

func give_buff(type: int):
	has_buff = true
	if not buff_timer.is_stopped():
		cleanse_buffs()
	buff_timer.start()

	match type:
		Global.crop_types.DAMAGE:
			hit_box.damage *= 2
			modulate = Color(0,0,0)
		Global.crop_types.SPEED:
			SPEED *= 2
			modulate = Color(255,255,255)
