extends Spatial

export (Array, PackedScene) var buildings

func _ready() -> void:
	for i in range(get_child_count()):
		randomize()
		var chance = rand_range(0, 3)
		chance = int(chance)
		if chance == 0 or chance == 1:
			randomize()
			var b_type = rand_range(0, len(buildings))
			b_type = int(b_type)
			var b = buildings[b_type].instance()
			b.rotation_degrees.y = rand_range(0, 179)
			get_child(i).add_child(b)

