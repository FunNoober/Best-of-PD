extends Attachement

export var light : NodePath
export var light_parent : NodePath
export var ray : NodePath
export var laser : NodePath

func _process(delta: float) -> void:
	get_node(light_parent).global_transform.origin = get_node(ray).get_collision_point()
	get_node(light).translation = get_node(ray).get_collision_normal() * 0.1
	
	if get_node(ray).is_colliding() == false:
		get_node(light_parent).translation = Vector3(0,0,0)
	
func use():
	if enabled == true:
		enabled = false
		get_node(light).hide()
		return
	if enabled == false:
		enabled = true
		get_node(light).show()
		return
