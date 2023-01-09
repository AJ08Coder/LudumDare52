extends Node

# only use this for refereces

enum crop_types {
	SPEED,
	DAMAGE,
	HEALTH,
	TELEPORT
}

var world_node : Node
var tele_ref : ReferenceRect


func get_tele_pos() -> Vector2:
	var x = int(tele_ref.rect_position.x) + (randi() % (int(tele_ref.rect_size.x) - int(tele_ref.rect_position.x)))
	var y = int(tele_ref.rect_position.y) + (randi() % (int(tele_ref.rect_size.y) - int(tele_ref.rect_position.y)))
	return Vector2(x, y)
