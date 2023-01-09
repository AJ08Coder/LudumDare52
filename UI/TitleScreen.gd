extends Control

onready var play: Button = $Play
onready var quit: Button = $Quit

func _ready() -> void:
	get_tree().paused = false
	quit.connect("pressed", self, "quit")
	play.connect("pressed", self, "play")


func play():
	get_tree().change_scene("res://Enviroment/World.tscn")
	SoundManager.click.play()


func quit():
	get_tree().quit()
	SoundManager.click.play()


