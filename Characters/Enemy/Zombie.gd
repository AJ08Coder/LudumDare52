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
			hit_box.damage *= 3
			buff_animation_player.play("Strength")
		Global.crop_types.SPEED:
			SPEED *= 2
			buff_animation_player.play("Speed")
		Global.crop_types.HEALTH:
			if not health >= 100:
				health += 10

		Global.crop_types.TELEPORT:
			self.global_position = Global.get_tele_pos()
