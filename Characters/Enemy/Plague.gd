extends Area2D

enum {
	IDLE,
	COLLECT
}

var state = IDLE

func _process(delta):
	match state:
		IDLE:
			$Sprite.rotation_degrees += 1
			$AnimationPlayer.play("RESET")
		COLLECT:
			$Sprite.rotation_degrees += 1
			$AnimationPlayer.play("Collect")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Collect":
		queue_free()
