extends "res://Characters/Hurtbox.gd"



func _on_area_entered(hitbox: HitBox):
	# changing this function to get a reference to the enemy or player
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox)
