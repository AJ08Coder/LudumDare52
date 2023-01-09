extends RichTextLabel

var times = ["1:00","2:00","3:00","4:00","5:00","6:00","7:00"
,"8:00","9:00","10:00","11:00","12:00"]

var timeindex = 0

func _ready():
	text = "Time: " + str(times[timeindex])

func _on_Timer_timeout():
	if timeindex >= 12:
		timeindex = 0
	timeindex += 1
	text = "Time: " + str(times[timeindex])
