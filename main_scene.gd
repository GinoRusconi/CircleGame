extends Node2D

var shake_timer := 0.0
var shake_strength := 8.0  # podés subirlo o bajarlo

func start_shake(time := 0.15):
	shake_timer = time

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		position = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		position = Vector2.ZERO
