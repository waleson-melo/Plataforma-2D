extends Area2D

export var fruits: int = 1

func _on_Items_body_entered(_body: Node) -> void:
	$AnimationPlayer.play("Collected")
	Global.fruits += fruits

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Collected":
		queue_free()
