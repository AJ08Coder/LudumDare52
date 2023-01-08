extends CanvasModulate

export(Color) var night_color
export(Color) var day_color
onready var rich_text_label = $"../CanvasLayer/RichTextLabel"
export var time = 1 # 1 = day 0 = night

func _ready():
	color = day_color
	$AnimationPlayer.play("RESET")

func _process(delta):
	rich_text_label.text = "time: " + str(round($Time.time_left))
	print(time)

func _on_Time_timeout():
	if time == 1:
		$AnimationPlayer.play("DaytoNight")
		print("day to night")
	elif time == 0:
		$AnimationPlayer.play("NighttoDay")
		print("night to day")
	else:
		print("No time set")
