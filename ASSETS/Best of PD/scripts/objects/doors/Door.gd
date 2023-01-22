extends Spatial

var opened = false
var peeked = false

export var open_angle = 90
export var peek_angle = 15
export var close_angle = 0

func _on_PeekDoor_Door_Action(action_type) -> void:
	if peeked == true and opened == false:
		rotation_degrees.y = close_angle
		peeked = false
		opened = false
		return
	if peeked == false and opened == true:
		rotation_degrees.y = peek_angle
		peeked = true
		opened = false
		return
	if peeked == false and opened == false:
		rotation_degrees.y = peek_angle
		peeked = true
		return

func _on_OpenDoor_Door_Action(action_type) -> void:
	if peeked == true and opened == false:
		rotation_degrees.y = open_angle
		opened = true
		peeked = false
		return
	if peeked == false and opened == true:
		rotation_degrees.y = close_angle
		opened = false
		peeked = false
		return
	if peeked == false and opened == false:
		rotation_degrees.y = open_angle
		opened = true
		return
