extends KinematicBody2D

export(PackedScene) var crop : PackedScene

var tile_size = 16

var speed = 80
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

func plant_seed():
	var spot := Vector2.ZERO
	# may need to offset it later (after stepify step)
	spot.x = stepify($Sprite/FootCheck.position.x, tile_size)
	spot.y = stepify($Sprite/FootCheck.position.y, tile_size)
	var

#Enemy AI

func _on_Attract_body_entered(body):
	#Enemy In range
	if body.is_in_group("Enemy"):
		body.attack_timer.start() # stay at boundry for certain time then attack


func _on_Attract_body_exited(body):
	#Enemy not in range
	if body.is_in_group("Enemy"):
		body.attack_timer.stop() # Cancel attack timer
		body.state = body.SURROUND # surround player
		body.randomize_circle_pos()


func _on_Attack_body_entered(body):
	#Enemy in range to attack with weapon
	if body.is_in_group("Enemy"):
		body.state = body.ATTACK # attack player

func _on_Attack_body_exited(body):
	#Enemy not in range to attack with weapon
	if body.is_in_group("Enemy"):
		body.attack_timer.start()
		body.state = body.SURROUND # surround player
