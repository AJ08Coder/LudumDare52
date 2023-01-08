extends CanvasModulate

onready var timelabel = $"../CanvasLayer/Time"

export var time = 1 # 1 = day 0 = night

signal turned_day_time
signal turned_night_time

func _turned_time(day):
	emit_signal(day)

func _ready():
	$AnimationPlayer.play("RESET")

func _process(delta):
#	pass
	timelabel.text = "Time: " + str(round($Time.time_left))

func _on_Time_timeout():
	if time == 1:
		$AnimationPlayer.play("DaytoNight")
		print("day to night")
	elif time == 0:
		$AnimationPlayer.play("NighttoDay")
		print("night to day")
	else:
		print("No time set")
