extends Node2D


onready var type = Global.crop_types.keys()[randi() % Global.crop_types.size()]


func take_damage(hitbox):
	# activate effect
	var attacker = hitbox.get_owner()

	attacker.give_buff(type)


	# do a chopped crop animation then call queue_free
	print("hit crop")
	queue_free()


func _exit_tree() -> void:
	if is_queued_for_deletion():
		Global.world_node.crop_spots.erase(global_position)
