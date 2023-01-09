extends Node2D


onready var type = Global.crop_types.get(Global.crop_types.keys()[randi() % Global.crop_types.size()])

var SpeedPlant = preload("res://Art/crop.png")
var TeleportPlant = preload("res://Art/TeleportPlant.png")
var HealthPlant  = preload("res://Art/HealthPlant.png")
var StrengthPlant = preload("res://Art/StrengthPlant.png")
var harvestsound = preload("res://Sounds/Harvest.tscn")

onready var sprite: Sprite = $Sprite

var enemies_in_range = []
onready var attract_coll = $Attract/CollisionShape2D
onready var dmgspot_coll = $DamageSpot/CollisionShape2D
var current_attacker = null
onready var life = $Life
func _ready() -> void:
	match type:
		Global.crop_types.SPEED:
			sprite.texture = SpeedPlant
		Global.crop_types.DAMAGE:
			sprite.texture = StrengthPlant
		Global.crop_types.HEALTH:
			sprite.texture = HealthPlant
		Global.crop_types.TELEPORT:
			sprite.texture = TeleportPlant

func take_damage(hitbox):
	# activate effect
	var attacker = hitbox.get_owner()

	attacker.give_buff(type)

	if type == Global.crop_types.TELEPORT:
		SoundManager.teleport.play()

	# do a chopped crop animation then call queue_free

	SoundManager.harvest.global_position = global_position
	SoundManager.harvest.play()
	queue_free()


func _exit_tree() -> void:
	if is_queued_for_deletion():
		Global.world_node.crop_spots.erase(global_position)


func _on_Attract_body_entered(body): # in reange
	if body.is_in_group("Enemy"): # Is enemy
		enemies_in_range.append(body) # add to range
		body.crop_target = self # follow crop
		body.state = body.FOLLOWCROP

func _on_DamageSpot_body_entered(body): # in range to damage
	if body.is_in_group("Enemy"):# is enemy
		if body in enemies_in_range: # is in range
			body.state = body.DAMAGECROP # stop moving
			life.start()
			current_attacker = enemies_in_range[0] # first to attack is current


func _on_Attract_body_exited(body): # enemy left range
	if body.is_in_group("Enemy"): # is enemy
		enemies_in_range.erase(body) #erase from range



func _on_Life_timeout(): # end of life
	if current_attacker in enemies_in_range:
		current_attacker.give_buff(type)
		current_attacker.state = current_attacker.SWITCHTOSURR
		for i in enemies_in_range:
			i.state = i.SWITCHTOSURR
		SoundManager.harvest.global_position = global_position
		SoundManager.harvest.play()
		queue_free()
