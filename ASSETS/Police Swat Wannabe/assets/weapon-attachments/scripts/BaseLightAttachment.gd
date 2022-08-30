extends Attachement

export var light : NodePath

func use():
	if enabled == true:
		enabled = false
		get_node(light).hide()
		return
	if enabled == false:
		enabled = true
		get_node(light).show()
		return
