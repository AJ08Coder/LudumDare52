extends KinematicBody2D

var target

var veloctiy = Vector2(0,1)

var SPEED = 130

func _ready() -> void:
	veloctiy = target - position
	$Sprite.rotation = veloctiy.angle()
func _process(delta: float) -> void:
	move_and_slide(veloctiy.normalized() * SPEED) #no steering





func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
