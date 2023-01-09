extends Control


onready var retry: Button = $CenterContainer/VBoxContainer/Retry
onready var quit: Button = $CenterContainer/VBoxContainer/Quit


func _ready() -> void:
	visible = false
	$AnimationPlayer.play("RESET")
	retry.connect("pressed", self, "retry_pressed")
	quit.connect("pressed", self, "quit_pressed")


func retry_pressed():
	get_tree().reload_current_scene()


func quit_pressed():
	get_tree().quit()


func game_over():
	visible = true
	get_tree().paused = true
	$AnimationPlayer.play("Blur")

