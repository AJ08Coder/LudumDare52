extends "res://Characters/Enemy/Enemy.gd"

func _process(delta):
	$HitBox.look_at(player.global_position)
