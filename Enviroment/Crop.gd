extends Node2D


func _ready() -> void:
	pass


func _exit_tree() -> void:
	if is_queued_for_deletion():
		Global.world_node.crop_spots.erase(global_position)
