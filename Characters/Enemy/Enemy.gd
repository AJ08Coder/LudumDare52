
extends KinematicBody2D

export var SPEED = 30
var velocity = Vector2.ZERO
export var health = 3


onready var anim = $AnimationPlayer
onready var switch_pos_timer = $SwitchPosTimer
onready var sprite = $Sprite
onready var attack_timer = $StartAttractTimer
onready var stunned_timer = $StunnedTimer
#onready var rays = $rays


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

func randomize_circle_pos():
	rng.randomize()
	randomno = rng.randf()
	
func _ready():
	randomize_circle_pos()
	anim.play("idle")
 
func _physics_process(delta):

	match state:

		SURROUND:
			move(get_circle_position(randomno), delta)
			anim.play("Moving")
			print("SURROUND")
		FOLLOW:
			move(player.global_position, delta)
			anim.play("Moving")
			pass
			print("FOLLOW")
			#state = SURROUND
		ATTACK:
			var hit_anims = ["Slash"]
			var rand_anim  = choose(hit_anims)
			move(player.global_position, delta)
			print("ATTACK")
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
	
	
	#$MeeleHitBox.look_at(player.global_position)
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




func avoid_obstacle_steering():
	pass
	#rays.rotation = velocity.angle()
	
	#for ray in rays.get_children():
	#	ray.cast_to.x = velocity.length()
	#	if ray.is_colliding():
	#		if ray.get_collider().is_in_group("Enemy"):
#				var obstacle = ray.get_collider()
#				return (global_position + velocity - obstacle.global_position).normalized() * avoid_force
			
	return Vector2.ZERO









func _on_StartAttractTimer_timeout():
	state = ATTACK
