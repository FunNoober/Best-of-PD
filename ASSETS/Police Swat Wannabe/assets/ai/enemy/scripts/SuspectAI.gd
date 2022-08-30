extends KinematicBody

var vel = Vector3.ZERO

var next_node_in_path : Vector3
var target : Vector3

export var nav_agent_ref : NodePath
export var shoot_timer_ref : NodePath
export var shoot_cast_ref : NodePath
export var vision_area_ref : NodePath
export var weapon_ref : NodePath
export var vision_cast_ref : NodePath
export var mov_speed : float

var nav_agent : NavigationAgent
var shoot_timer : Timer
var shoot_cast : RayCast
var vision_cast : RayCast
var vision_area : Area
var weapon : Spatial
var spotted_enemy : Spatial
var is_seeing_enemy : bool

enum AGGRESSIVE_TYPE {
	defensive,
	offensive
}

export (AGGRESSIVE_TYPE) var aggressive_type = AGGRESSIVE_TYPE.defensive

func _ready() -> void:
	nav_agent = get_node(nav_agent_ref)
	shoot_timer = get_node(shoot_timer_ref)
	shoot_cast = get_node(shoot_cast_ref)
	vision_area = get_node(vision_area_ref)
	weapon = get_node(weapon_ref)
	vision_cast = get_node(vision_cast_ref)
	
	nav_agent.connect("velocity_computed", self, "velocity_computed")
	#nav_agent.connect("navigation_finished", self, "navigation_finished")
	vision_area.connect("body_entered", self, "vision_entered")

func _process(delta: float) -> void:
	if spotted_enemy != null:
		vision_cast.look_at(spotted_enemy.get_node("Center").global_transform.origin, Vector3.UP)
		if vision_cast.get_collider():
			if vision_cast.get_collider().is_in_group("swat"):
				is_seeing_enemy = true
			else:
				is_seeing_enemy = false
		if is_seeing_enemy:
			look_at(spotted_enemy.global_transform.origin, Vector3.UP)
			weapon.look_at(spotted_enemy.get_node("Center").global_transform.origin, Vector3.UP)
		if aggressive_type == AGGRESSIVE_TYPE.offensive and global_transform.origin.distance_to(spotted_enemy.global_transform.origin) > 15:
			set_location()
			do_moving(delta)

func vision_entered(body: Node) -> void:
	if body.is_in_group("swat"):
		spotted_enemy = body

func do_moving(delta):
	next_node_in_path = nav_agent.get_next_location()
	var dir = global_transform.origin.direction_to(next_node_in_path)
	var steering = (dir - vel) * delta * mov_speed
	vel += steering
	nav_agent.set_velocity(vel * delta * mov_speed)

func set_location():
	nav_agent.set_target_location(spotted_enemy.global_transform.origin)

func velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)
