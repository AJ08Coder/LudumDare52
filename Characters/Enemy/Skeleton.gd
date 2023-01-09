extends "res://Characters/Enemy/Enemy.gd"
onready var hand: Node2D = $Hand

var arrow = preload("res://Characters/Enemy/Arrow.tscn")

func _process(delta: float) -> void:
	hand.look_at(player.global_position)
	
func _physics_process(delta: float) -> void:
	match state:
		FOLLOW: # follows the player
			if state != FOLLOWCROP:
				randomize_circle_pos()
				move(get_circle_position(randomno), delta)
				play_anim(moving_anim)
			else:
				state = FOLLOWCROP
		ATTACK:# attacks player with weapon
			if state != FOLLOWCROP:
				randomize_circle_pos()
				move(get_circle_position(randomno), delta)
				play_anim(moving_anim)
			else:
				state = FOLLOWCROP

func give_buff(type: int):
	has_buff = true
	if not buff_timer.is_stopped():
		cleanse_buffs()
	buff_timer.start()

	match type:
		Global.crop_types.DAMAGE:
			
			buff_animation_player.play("Strength")
		Global.crop_types.SPEED:
			SPEED *= 2
			buff_animation_player.play("Speed")
		Global.crop_types.HEALTH:
			if not health >= 100:
				show_health_bar()
				health += 10

		Global.crop_types.TELEPORT:
			self.global_position = Global.get_tele_pos()


func _on_SwitchPos_timeout() -> void:
	randomize_circle_pos()

func _shoot(target):
	var instance = arrow.instance()
	instance.global_position = global_position
	instance.target = target
	get_parent().add_child(instance)

func _on_ShootTimer_timeout() -> void:
	$BowAnim.play("Shoot")
	_shoot(player.global_position)
	
