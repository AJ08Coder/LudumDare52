
extends KinematicBody2D

var SPEED = 30
var velocity = Vector2.ZERO
var health = 3


onready var anim = $AnimationPlayer
onready var switch_pos_timer = $SwitchPosTimer
onready var sprite = $Sprite
onready var attack_timer = $StartAttractTimer
onready var stunned_timer = $StunnedTimer
onready var rays = $rays


var player
var avoid_force = 5
var target
var randomno
onready var rng = RandomNumberGenerator.new()


enum {
	SURROUND,
	FOLLOW,
	ATTACK,
	STUNNED,
	HURT,
	DIE
}

var state = SURROUND

func _ready():
	print(rays)
	rng.randomize()
	randomno = rng.randf()
	target = get_circle_position(randomno)
	anim.play("idle")
	switch_pos_timer.wait_time = rng.randf_range(2.4,5)
 
func _physics_process(delta):
	match state:

		SURROUND:
			move(get_circle_position(randomno), delta)
			anim.play("Moving")
		FOLLOW:
			move(player.global_position, delta)
			anim.play("Moving")
			pass
			#state = SURROUND
		ATTACK:
			var hit_anims = ["Slash"]
			var rand_anim  = choose(hit_anims)
			move(player.global_position, delta)
			
			anim.play(rand_anim)
		DIE:

			queue_free()
		STUNNED:
			velocity = Vector2.ZERO # Stops movement
			if stunned_timer.time_left == stunned_timer.wait_time: # Freezes for wait_time
				stunned_timer.start()
		HURT:
			# DIE
			if health <= 0: 
				queue_free()
			# GET HIT
			anim.play("Hit")
			health -= 1
			state = STUNNED
		
	
			

func move(target, delta):
	var direction = (target - global_position).normalized() 
	#move_and_slide(direction * SPEED) #no steering
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	steering += avoid_obstacle_steering()
	velocity += steering
	velocity = move_and_slide(velocity)
	
	
	$MeeleHitBox.look_at(player.global_position)
	if player.global_position.x > global_position.x:
		sprite.scale.x = 1
		#$MeeleHitBox.scale.y = 1
		#$MeeleHurtBox.scale.y = 1
	elif player.global_position.x < global_position.x:
		sprite.scale.x = -1
		#$MeeleHitBox.scale.y = -1
		#$MeeleHurtBox.scale.y = -1
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)
	
	

func take_damage():
	state = HURT
	

func choose(array):
	array.shuffle()
	return array.front()


func _on_Switch_Position_Timer():
	rng.randomize()
	randomno = rng.randf()
	switch_pos_timer.wait_time = rng.randf_range(2,4)
	#pass

func _on_AttackTimer_timeout():
	state = ATTACK



func avoid_obstacle_steering():
	rays.rotation = velocity.angle()
	
	for ray in rays.get_children():
		ray.cast_to.x = velocity.length()
		if ray.is_colliding():
			if ray.get_collider().is_in_group("Enemy"):
				var obstacle = ray.get_collider()
				return (global_position + velocity - obstacle.global_position).normalized() * avoid_force
			
	return Vector2.ZERO

func _on_StunnedTimer_timeout():
	state = ATTACK



