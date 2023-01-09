extends "res://Characters/Enemy/Enemy.gd"
onready var hit_box: Area2D = $HitBox

var demon = preload("res://Art/demon.png")

var default_damage = 10

func _ready() -> void:
	var rng = [1,2,3,4,5]
	if choose(rng) == 4:
		sprite.texture =demon
		hit_box.damage = 25
		default_damage = 25
		health= 200
		health_bar.max_value = 200

func _physics_process(delta: float) -> void:
	match state:
		FOLLOW: # follows the player
			if state != FOLLOWCROP:
				move(player.global_position, delta)
				play_anim(moving_anim)
			else:
				state = FOLLOWCROP
		ATTACK:# attacks player with weapon
			var hit_anims = [slash_anim]
			var rand_anim  = choose(hit_anims)
			move(player.global_position, delta)
			play_anim(rand_anim)

func _process(delta):
	$HitBox.look_at(player.global_position)

func give_buff(type: int):
	has_buff = true
	if not buff_timer.is_stopped():
		cleanse_buffs()
		hit_box.damage = default_damage
	buff_timer.start()

	match type:
		Global.crop_types.DAMAGE:
			hit_box.damage *= 3
			buff_animation_player.play("Strength")
		Global.crop_types.SPEED:
			SPEED *= 2
			buff_animation_player.play("Speed")
		Global.crop_types.HEALTH:
			if not health >= 100:
				health += 10
			show_health_bar()
		Global.crop_types.TELEPORT:
			instance_and_play_particle_at(global_position,Color(0.576471, 0.223529, 1))
			self.global_position = Global.get_tele_pos()
			instance_and_play_particle_at(global_position,Color(0.576471, 0.223529, 1))
