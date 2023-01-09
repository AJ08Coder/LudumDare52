extends CanvasModulate

onready var timelabel = $"../CanvasLayer/HBoxContainer/Time"
onready var day_time: Timer = $DayTime
onready var night_time: Timer = $NightTime
export var time = 1 # 1 = day 0 = night


signal turned_day_time
signal turned_night_time

func _turned_time(day):
	emit_signal(day)
	if day == "turned_night_time":
		night_time.start()
		time = 0
	elif day == "turned_day_time":
		day_time.start()
		time = 1

func _ready():
	$AnimationPlayer.play("RESET")

func _process(delta):
	if time == 1:
		timelabel.text = "Time: " + str(round(day_time.time_left))
	else:
		timelabel.text = "Time: " + str(round(night_time.time_left))



func _on_DayTime_timeout() -> void:
	if time == 1:
		$AnimationPlayer.play("DaytoNight")
		print("day to night")

	elif time == 0:
		$AnimationPlayer.play("NighttoDay")
		print("night to day")
	else:
		print("No time set")


func _on_NightTime_timeout() -> void:
	if time == 1:
		$AnimationPlayer.play("DaytoNight")
		print("day to night")
	elif time == 0:
		$AnimationPlayer.play("NighttoDay")
		print("night to day")
	else:
		print("No time set")

