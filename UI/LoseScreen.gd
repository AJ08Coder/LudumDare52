extends Control


onready var retry: Button = $CenterContainer/VBoxContainer/Retry
onready var exit: Button = $CenterContainer/VBoxContainer/Exit


func _ready() -> void:
	visible = false
	$AnimationPlayer.play("RESET")
	retry.connect("pressed", self, "retry_pressed")
	exit.connect("pressed", self, "exit_pressed")


func retry_pressed():
	SoundManager.click.play()
	get_tree().reload_current_scene()


func exit_pressed():
	SoundManager.click.play()
	get_tree().change_scene("res://UI/TitleScreen.tscn")


func game_over():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("Blur")

