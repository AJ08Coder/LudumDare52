extends RichTextLabel

var times = ["1:00","2:00","3:00","4:00","5:00","6:00","7:00"
,"8:00","9:00","10:00","11:00","12:00"]

var justinisuseless = 0

func _ready():
	text = "Time: " + str(times[justinisuseless])

func _on_Timer_timeout():
	if justinisuseless >= 12:
		justinisuseless = 0
	justinisuseless += 1
	text = "Time: " + str(times[justinisuseless])
