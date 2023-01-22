extends Camera

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		if $UseCast.is_colliding():
			var collider = $UseCast.get_collider()
			if collider.is_in_group("DoorInteract"):
				collider.use()
