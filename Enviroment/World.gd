extends Node2D

var souls = 0

var zombie = preload("res://Characters/Enemy/Zombie.tscn")

var wave = [3,10,20,0]
			# amount of enemies, last is win
onready var player = get_node("Player")



func _on_SpawnEnemies_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$GameLoop/Path2D/PathFollow2D.unit_offset = rng.randf_range(0,1)
	var instance = zombie.instance()
	instance.player = player
	instance.global_position = $GameLoop/Path2D/PathFollow2D/Position2D.global_position
	$Enemies.add_child(instance)
