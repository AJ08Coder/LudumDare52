extends Node2D

var souls = 0

var crop_spots = []

var zombie = preload("res://Characters/Enemy/Zombie.tscn")
onready var spawn_enemies = $GameLoop/SpawnEnemies
var wave = [3,10,20,0]
			# amount of enemies, last is win
export(NodePath) var player_path
onready var player = get_node(player_path)

func _ready() -> void:
	Global.world_node = self



func _on_SpawnEnemies_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$GameLoop/Path2D/PathFollow2D.unit_offset = rng.randf_range(0,1)
	var instance = zombie.instance()
	instance.player = player
	instance.global_position = $GameLoop/Path2D/PathFollow2D/Position2D.global_position
	$YSort/Enemies.add_child(instance)


func _on_Cycle_turned_night_time():
	spawn_enemies.start()


func _on_Cycle_turned_day_time():
	spawn_enemies.stop()
