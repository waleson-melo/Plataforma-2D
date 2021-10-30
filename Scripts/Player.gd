extends KinematicBody2D

var UP: Vector2 = Vector2.UP
var velocity: Vector2 = Vector2.ZERO
var move_speed: float = 480
var gravity: float = 1200
var force_jump: float = -400
var is_grounded: bool = false
var player_health: int = 3
var max_health: int = 3
var hurted: bool = false
var knockback_dir: int = 1
var knochback_int: float = 750
onready var ray_casts = $RayCasts

signal change_life(player_health)


func _ready() -> void:
	var _x = connect("change_life",
		get_parent().get_node("HUD/HBoxContainer/Holder"), "on_change_life")
	emit_signal("change_life", max_health)
	position.x = Global.checkpoint_pos 


func _physics_process(delta: float) -> void:
	velocity.x = 0
	if !is_grounded:
		velocity.y += gravity * delta
		if velocity.y > 280:
			velocity.y = 280
	elif velocity.y > 5:
		velocity.y = 5

	if !hurted:
		_get_input()
	
	var _mov = move_and_slide(velocity, UP)
	
	is_grounded = _check_is_grounded()

	_set_animation()
	
	for platforms in get_slide_count():
		var collision = get_slide_collision(platforms)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)


func _get_input() -> void:
	velocity.x = 0

	var move_direction = int(Input.is_action_pressed("ui_right")) - int(
			Input.is_action_pressed("ui_left"))

	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)

	if Input.is_action_pressed("ui_accept") and is_grounded:
		velocity.y = force_jump

	if move_direction != 0:
		$Sprite.scale.x = move_direction
		knockback_dir = move_direction


func _check_is_grounded() -> bool:
	for ray_cast in ray_casts.get_children():
		if ray_cast.is_colliding():
			return true
	return false


func _set_animation() -> void:
	var anim = "Idle"

	if !is_grounded:
		anim = "Jump"
	elif velocity.x != 0:
		anim = "Run"
		$CPUParticles2D.emitting = true

	if velocity.y > 0 and !is_grounded:
		anim = "Fall"

	if hurted:
		anim = "Hit"

	if $AnimationPlayer.assigned_animation != anim:
		$AnimationPlayer.play(anim)


func _knockback() -> void:
	if $RayCast2DR.is_colliding():
		velocity.x = -knockback_dir * knochback_int
		print(velocity.x)

	elif $RayCast2D2L.is_colliding():
		velocity.x = knockback_dir * knochback_int

	velocity = move_and_slide(velocity)


func _on_Hurtbox_body_entered(_body) -> void:
	player_health -= 1
	hurted = true
	emit_signal("change_life", player_health)
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", true)
	_knockback()

	yield(get_tree().create_timer(0.5), "timeout")
	get_node("Hurtbox/CollisionShape2D").set_deferred("disabled", false)	
	hurted = false
	if player_health <= 0:
		queue_free()
		var _x = get_tree().reload_current_scene()


func hit_checkpoit():
	Global.checkpoint_pos = position.x + 50
