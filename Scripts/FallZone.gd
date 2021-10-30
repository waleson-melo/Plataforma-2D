extends Area2D


func _on_FallZone_body_entered(_body):
	var _x = get_tree().reload_current_scene()
