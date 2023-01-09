extends Node2D

var souls = 0

var crop_spots = []

var day = 0

var skeleton = preload("res://Characters/Enemy/Skeleton.tscn")
var zombie = preload("res://Characters/Enemy/Zombie.tscn")
onready var spawn_enemies = $GameLoop/SpawnEnemies
var wave: Array = 		[5,10,16,30]
			# amount of enemies
var nightlength: Array = [15,30,50,60]
export(NodePath) var player_path
onready var player = get_node(player_path)
onready var player_health_bar = $CanvasLayer/HBoxContainer/PlayerHealthBar
onready var crops = $YSort/Crops
onready var wavetext: RichTextLabel = $CanvasLayer/HBoxContainer/Wave

var instance
var enemiesspawned = 0

func _ready() -> void:
	Global.world_node = self
	Global.tele_ref = $TeleportReference
	player.connect("health_changed", self, "player_health_changed")

func _process(delta: float) -> void:
	wavetext.text = "Day: " + str(day+1)

func _on_SpawnEnemies_timeout():
	if not enemiesspawned >= wave[day]:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		$GameLoop/Path2D/PathFollow2D.unit_offset = rng.randf_range(0,1)
		if enemiesspawned >= wave[day]/2:
			instance = zombie.instance()
		else:
			instance = skeleton.instance()
		instance.player = player
		instance.crops = crops
		instance.crop_path = crops.get_path()
		instance.global_position = $GameLoop/Path2D/PathFollow2D/Position2D.global_position
		$YSort/Enemies.add_child(instance)
		enemiesspawned += 1

	
func player_health_changed(currenthealth):
	player_health_bar.value = currenthealth

func _on_Cycle_turned_night_time():
	spawn_enemies.start()
	$Cycle/NightTime.wait_time = nightlength[day]
	if day >= nightlength.size():
		day = nightlength.size() -1
	
func _on_Cycle_turned_day_time():
	spawn_enemies.stop()
	enemiesspawned = 0
	day += 1
	if day >= wave.size():
		day = wave.size() -1
