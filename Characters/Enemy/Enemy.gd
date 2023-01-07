extends KinematicBody2D

var speed = 50

var velocity = Vector2()

onready var player = get_parent().get_node("Player")

var proximity = []

enum {
	IDLE,
	ATTACK,
	FIGHT,
	CURING
}

var state = IDLE

func _physics_process(delta):
	match state:
		IDLE:
			velocity = Vector2()
	
		ATTACK:
			move(player.global_position, delta)

		FIGHT:
			pass
		CURING:
			velocity = global_position.direction_to(player.global_position)
			move_and_slide(velocity * 40)
			print("Fdsf")
		


func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	velocity = move_and_slide(velocity)

func _on_Attract_body_entered(body):
	if body.is_in_group("Player"):
		if state != CURING:
			state = ATTACK
			
