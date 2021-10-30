extends Area2D


func _ready() -> void:
	pass


func _on_Checkpoint_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.hit_checkpoit()
		$AnimationPlayer.play("Checked")
		$CollisionShape2D.queue_free()
