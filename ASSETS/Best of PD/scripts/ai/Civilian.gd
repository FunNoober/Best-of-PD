extends KinematicBody

enum STATES {
	idle,
	startled,
	flee,
	surrender,
	resist,
	dead
}

var state = STATES.idle
var surrender_count : int = 0
onready var cur_health : float = data.health

export var data : Resource

func _process(delta: float) -> void:
	if cur_health <= 0:
		state = STATES.dead
	
	match state:
		STATES.idle:
			idle()
		STATES.startled:
			startled()
		STATES.flee:
			flee()
		STATES.surrender:
			surrender()
		STATES.resist:
			resist()
		STATES.dead:
			dead()

func idle():
	pass

func startled():
	randomize()
	var percent = int(rand_range(1, 3))
	if percent == 1:
		state = STATES.flee
	if percent == 2:
		state = STATES.surrender
	if percent == 3:
		state = STATES.resist

func flee():
	pass

func surrender():
	pass
	
func resist():
	pass
	
func dead():
	queue_free()

func startle():
	if state == STATES.idle:
		state = STATES.startled
