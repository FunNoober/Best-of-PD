extends Spatial

enum DOOR_STATES {
	closed,
	peek,
	opened
}

enum OPEN_DIRECTIONS {
	closed,
	front,
	back
}

var door_state = DOOR_STATES.closed
var open_direction = OPEN_DIRECTIONS.closed

export var peek_angle_front = 15
export var open_angle_front = 90
export var peek_angle_back = -15
export var open_angle_back = -90
export var start_angle = 90

func _process(delta: float) -> void:
	match door_state:
		DOOR_STATES.closed:
			rotation_degrees.y = lerp(rotation_degrees.y, start_angle, delta * 3)
		DOOR_STATES.peek:
			if open_direction == OPEN_DIRECTIONS.front:
				rotation_degrees.y = lerp(rotation_degrees.y, peek_angle_front, delta * 3)
			if open_direction == OPEN_DIRECTIONS.back:
				rotation_degrees.y = lerp(rotation_degrees.y, peek_angle_back, delta * 3)
		DOOR_STATES.opened:
			if open_direction == OPEN_DIRECTIONS.front:
				rotation_degrees.y = lerp(rotation_degrees.y, open_angle_front, delta * 3)
			if open_direction == OPEN_DIRECTIONS.back:
				rotation_degrees.y = lerp(rotation_degrees.y, open_angle_back, delta * 3)

func peek(dir : int):
	if door_state == DOOR_STATES.closed:
		door_state = DOOR_STATES.peek
		open_direction = dir
		return
	if door_state == DOOR_STATES.opened:
		door_state = DOOR_STATES.peek
		open_direction = dir
		return
	if door_state == DOOR_STATES.peek:
		door_state = DOOR_STATES.closed
		open_direction = dir
		return

func open(dir : int):
	if door_state == DOOR_STATES.closed:
		door_state = DOOR_STATES.opened
		open_direction = dir
		return
	if door_state == DOOR_STATES.peek:
		door_state = DOOR_STATES.opened
		open_direction = dir
		return
	if door_state == DOOR_STATES.opened:
		door_state = DOOR_STATES.closed
		open_direction = dir
		return

func _on_PeekDoorFront_Door_Action(action_type) -> void:
	peek(OPEN_DIRECTIONS.front)
		
func _on_OpenDoorFront_Door_Action(action_type) -> void:
	open(OPEN_DIRECTIONS.front)

func _on_PeekDoorRear_Door_Action(action_type) -> void:
	peek(OPEN_DIRECTIONS.back)
	
func _on_OpenDoorRear_Door_Action(action_type) -> void:
	open(OPEN_DIRECTIONS.back)

