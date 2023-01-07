extends KinematicBody2D

var speed =80

var health = 100

onready var laser = $laser

func laser_fire(i):
	laser.enabled = i
	laser.visible = i

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up","move_down")
	var move_direction = input_vector.normalized()
	
	move_and_slide(speed * move_direction)
	
	if input_vector.x > 0:
		$Sprite.flip_h = false
	elif input_vector.x <0:
		$Sprite.flip_h = true
	
	if move_direction:
		$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("RESET")
	
	$Wand.look_at(get_global_mouse_position())
	laser.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("ui_accept"):
		laser_fire(true)
	else:
		laser_fire(false)

