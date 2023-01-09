extends CPUParticles2D

func _process(delta: float) -> void:
	if not is_emitting():
		queue_free()
