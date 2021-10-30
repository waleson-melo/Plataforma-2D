extends Node2D

onready var platform = $Platform
onready var tween: Tween = $Tween
export var speed: float = 3.0
export var horizontal: bool = true
export var distance: float = 192
var follow: Vector2 = Vector2.ZERO
const WAIT_DURATIN: float = 1.0

func _ready() -> void:
	_start_tween()


func _start_tween() -> void:
	var move_direction: Vector2 = Vector2.RIGHT * distance if (horizontal
		) else Vector2.UP * distance
	var duration: float = move_direction.length() / float(speed * 16)
	var _x = tween.interpolate_property(self, "follow", Vector2.ZERO,
		move_direction, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,
		WAIT_DURATIN)
	var _y = tween.interpolate_property(self, "follow", move_direction,
		Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,
		duration + WAIT_DURATIN * 2)
	var _z = tween.start()


func _physics_process(_delta: float) -> void:
	platform.position = platform.position.linear_interpolate(follow, 0.05)
