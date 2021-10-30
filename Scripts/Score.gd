extends Label


func _process(_delta: float) -> void:
	var zeros: String = "000"
	if Global.fruits >= 10:
		zeros = "00"

	text = zeros + String(Global.fruits)
