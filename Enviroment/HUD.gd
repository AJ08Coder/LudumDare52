extends CanvasLayer





func _on_FullScreen_toggled(button_pressed: bool) -> void:
	if button_pressed == true:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
