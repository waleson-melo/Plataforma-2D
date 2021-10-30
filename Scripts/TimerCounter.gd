extends Control


export (int) var minutes = 0
export (int) var seconds = 0

func _process(_delta: float) -> void:
	if minutes > 0 and seconds <= 0:
		minutes -= 1
		seconds = 60

	if seconds >= 10:
		$Seconds.text = ":" + str(seconds)
	else:
		$Seconds.text = ":0" + str(seconds)
	
	if minutes >= 10:
		$Minutes.text = str(minutes)
	else:
		$Minutes.text = "0" + str(minutes)
	
	if seconds <= 0:
		$Timer.stop()
		yield(get_tree().create_timer(1), "timeout")
		var _x = get_tree().reload_current_scene()


func _on_Timer_timeout() -> void:
	seconds -= 1
