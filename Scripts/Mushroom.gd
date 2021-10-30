extends KinematicBody2D


export var Speed: float = 2000
export var Health: int = 1
var move_direction: int = -1
var velocity: Vector2 = Vector2.ZERO
var gravity: float = 1200
var hitted: bool = false


func _physics_process(delta: float) -> void:
	velocity.x = Speed * move_direction * delta
	velocity = move_and_slide(velocity)
	velocity.y += gravity * delta

	$Sprite.flip_h = true if move_direction == 1 else false

	_set_animation()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Idle":
		$RayCast2D.scale.x *= -1
		move_direction *= -1
		$AnimationPlayer.play("Run")


func _on_Hitbox_body_entered(body) -> void:
	hitted = true
	body.velocity.y = body.force_jump
	Health -= 1

	yield(get_tree().create_timer(0.2), "timeout")
	hitted = false
	if Health == 0:
		queue_free()
		get_node("Hitbox/CollisionShape2D").set_deferred("disabled", true)


func _set_animation() -> void:
	var anim = "Run"

	if $RayCast2D.is_colliding():
		anim = "Idle"
	elif velocity.x != 0:
		anim = "Run"

	if hitted:
		anim = "Hit"

	if $AnimationPlayer.assigned_animation != anim:
		$AnimationPlayer.play(anim)
