extends KinematicBody2D

export(PackedScene) var crop : PackedScene

var tile_size = 16

var speed = 80
var health = 100

onready var hand = $Hand
onready var meele_weapon = $Hand/MeeleWeapon
onready var sprite = $Sprite
onready var animplayer = $AnimationPlayer
onready var plant_cooldown = $PlantCooldown

var crop_loc = []


func choose_rand_item(list): # chooses random item off list
	list.shuffle()
	return list[0]

func _physics_process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up","move_down")
	var move_direction = input_vector.normalized()

	move_and_slide(speed * move_direction)

	if input_vector.x != 0:
		sprite.flip_h = input_vector.x < 0

	if move_direction:
		animplayer.play("Walk")
	else:
		animplayer.play("RESET")

	hand.look_at(get_global_mouse_position())


	if Input.is_action_pressed("plant") and plant_cooldown.is_stopped():
		plant_seed()
		plant_cooldown.start()

func plant_seed():
	var spot := Vector2.ZERO
	# may need to offset it later (after stepify step)
	spot.x = stepify(hand.get_node("Action").global_position.x - tile_size/2, tile_size)
	spot.y = stepify(hand.get_node("Action").global_position.y - tile_size/2, tile_size)
	spot.x += tile_size/2
	spot.y += tile_size/2

	crop_loc.append(Vector2(spot.x,spot.y))
	# there is already a crop planted bish
	if Global.world_node.crop_spots.find(spot) != -1:
		return
	else:
		Global.world_node.crop_spots.append(spot)
	var crop_inst = crop.instance()
	# crop params go here later
	crop_inst.global_position = spot
	get_parent().get_node("Crops").add_child(crop_inst)

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
