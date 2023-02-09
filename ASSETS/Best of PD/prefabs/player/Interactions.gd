extends Camera

var collider

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		if $UseCast.is_colliding():
			collider = $UseCast.get_collider()
			if collider.is_in_group("I"):
				collider.use()
			return
		if $ShoutCast.is_colliding():
			collider = $ShoutCast.get_collider()
			if collider.is_in_group("Ci"):
				collider.startle()
