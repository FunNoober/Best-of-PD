extends Interaction_Base

signal Door_Action(action_type)
enum DOOR_ACTION_TYPES {
	open,
	peek
}

export (DOOR_ACTION_TYPES) var door_action_type = DOOR_ACTION_TYPES.open

func use():
	emit_signal("Door_Action", door_action_type)
