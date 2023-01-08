extends KinematicBody2D

export var SPEED = 30
export var radius = 40
export var health = 3

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var attack_timer = $StartAttractTimer
onready var stunned_timer = $StunnedTimer

var rng = RandomNumberGenerator.new()

var damage_taken
var player #var declared in world script 
var avoid_force = 5
var target
var randomno
var velocity = Vector2.ZERO



enum {
	SURROUND,
	FOLLOW,
	ATTACK,
	STUNNED,
	HURT
}

var state = SURROUND

func randomize_circle_pos(): # randomizes random pos around the player
	rng.randomize()
	randomno = rng.randf()

func _ready():
	randomize_circle_pos()
	anim.play("idle")

func _physics_process(delta):
	match state:
		SURROUND: # surrounds player
			move(get_circle_position(randomno), delta)
			anim.play("Moving")
		FOLLOW: # follows the player
			move(player.global_position, delta)
			anim.play("Moving")
		ATTACK:# attacks player with weapon
			var hit_anims = ["Slash"]
			var rand_anim  = choose(hit_anims)
			move(player.global_position, delta)
			anim.play(rand_anim)
		STUNNED: # freezes when hit
			velocity = Vector2.ZERO # Stops movement
			if stunned_timer.time_left == stunned_timer.wait_time: # Freezes for wait_time
				stunned_timer.start()
		HURT:# gets hit by player 
			# DIE
			if health <= 0:
				queue_free()
			# GET HIT
#			anim.play("Hit")
			health -= damage_taken
			state = STUNNED




func move(target, delta): # moves enemy to target
	var direction = (target - global_position).normalized()
	#move_and_slide(direction * SPEED) #no steering
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
#	steering += avoid_obstacle_steering()
	velocity += steering
	velocity = move_and_slide(velocity)


	#$MeeleHitBox.look_at(player.global_position)
	if player.global_position.x > global_position.x:  # flips sprite depending on where player is located
		sprite.scale.x = 1
		#$MeeleHitBox.scale.y = 1
		#$MeeleHurtBox.scale.y = 1
	elif player.global_position.x < global_position.x:
		sprite.scale.x = -1
		#$MeeleHitBox.scale.y = -1
		#$MeeleHurtBox.scale.y = -1
		
func get_circle_position(random): # gets position around player
	var kill_circle_centre = player.global_position
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)



func take_damage(amount): # run when enemy takes damage from player
	damage_taken = amount
	state = HURT


func choose(array): # chooses random item in array
	array.shuffle()
	return array.front()




func avoid_obstacle_steering():
	pass
#	rays.rotation = velocity.angle()
#	for ray in rays.get_children():
#		ray.cast_to.x = velocity.length()
#		if ray.is_colliding():
#			if ray.get_collider().is_in_group("Enemy"):
#				var obstacle = ray.get_collider()
#				return (global_position + velocity - obstacle.global_position).normalized() * avoid_force
#	return Vector2.ZERO



func _on_StartAttractTimer_timeout(): # attacks player after surrounding player for certain time
	state = ATTACK
