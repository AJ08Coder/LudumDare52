extends AudioStreamPlayer2D



func _on_Harvest_finished() -> void:
	queue_free()
