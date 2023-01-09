extends KinematicBody2D

export var SPEED: int = 30
export var radius: int = 40
export var health: int = 100

var has_buff = false
onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var attack_timer = $StartAttractTimer
onready var stunned_timer = $StunnedTimer
onready var buff_timer: Timer = $BuffTimer
onready var health_bar: ProgressBar = $HealthBar
onready var health_bar_timer: Timer = $HealthBarTimer
onready var buff_anim_timer: Timer = $BuffAnimTimer
onready var buff_animation_player: AnimationPlayer = $BuffAnimationPlayer

var particle = preload("res://Enviroment/ExpolsiveParticle.tscn")

export(String) var moving_anim
export(String) var idle_anim
export(String) var slash_anim
export(String) var hurt_anim
export(Color) var modulate_color

var crops

var rng = RandomNumberGenerator.new()

var damage_taken
var player #var declared in world script
var avoid_force = 5
var target
var randomno
var velocity = Vector2.ZERO
var crop_target
var crop_path

export var main_target = "player"

func play_anim(animation):
	anim.play(animation)




enum {
	SURROUND,
	FOLLOW,
	ATTACK,
	STUNNED,
	HURT,
	FOLLOWCROP,
	DAMAGECROP,
	SWITCHTOSURR
}

var state = SURROUND

func cleanse_buffs():
	SPEED = 30
	modulate = modulate_color
	buff_animation_player.play("RESET")
	has_buff = false





func randomize_circle_pos(): # randomizes random pos around the player
	rng.randomize()
	randomno = rng.randf()

func _ready():
	randomize_circle_pos()
	play_anim(idle_anim)
	modulate = modulate_color
	buff_animation_player.play("RESET")


func show_health_bar():
	health_bar.visible = true
	health_bar_timer.start()

func _physics_process(delta):
	match state:
		SURROUND: # surrounds player
			if state != FOLLOWCROP:
				move(get_circle_position(randomno), delta)
				play_anim(moving_anim)
			else:
				state = FOLLOWCROP

		STUNNED: # freezes when hit
			velocity = Vector2.ZERO # Stops movement
			if stunned_timer.time_left == stunned_timer.wait_time: # Freezes for wait_time
				stunned_timer.start()
		HURT:# gets hit by player
			# DIE
			health -= damage_taken
			if health <= 0:
				queue_free()

			# GET HIT
			show_health_bar()
			play_anim(hurt_anim)

			state = STUNNED
		FOLLOWCROP:
			if has_buff == false:
				if is_instance_valid(crop_target) == true:
					move(crop_target.global_position, delta)
					play_anim(moving_anim)
				else:
					state = SWITCHTOSURR
			else:
				state = SWITCHTOSURR
		DAMAGECROP:
			velocity = Vector2()
			play_anim(idle_anim)
		SWITCHTOSURR:
			state = SURROUND

func _process(delta: float) -> void:
	health_bar.value = health

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

func _crop_destroyed():
	print("test")
	crop_target = null




func _on_StartAttractTimer_timeout(): # attacks player after surrounding player for certain time
	state = ATTACK


func instance_and_play_particle_at(loc, color):
	var instance = particle.instance()
	instance.global_position = loc
	instance.modulate = color
	get_parent().add_child(instance)
	instance.emitting = true
	if not instance.is_emitting():
		instance.queue_free()

func _on_StunnedTimer_timeout():
	state = SURROUND


func _on_BuffTimer_timeout() -> void:
	cleanse_buffs()


func _on_HealthBarTimer_timeout() -> void:
	health_bar.visible = false


func _on_BuffAnimTimer_timeout() -> void:
	cleanse_buffs()
