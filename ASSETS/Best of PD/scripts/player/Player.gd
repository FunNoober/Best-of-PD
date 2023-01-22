extends KinematicBody

var vel = Vector3()
var dir = Vector3()

const default_move_speed : float = 4.0

var mov_speed = 4
var sprint_mov_speed = 8
var grounded : bool = true
var is_leaning_left : bool = false
var is_leaning_right : bool = false
var is_crouching : bool = false

onready var cam = $BodyCollider/CamRot/Camera
onready var cam_rot = $BodyCollider/CamRot

export (OpenSimplexNoise) var noise
export (float, 0, 1) var trauma = 0.0
export (float, 0, 1) var decay = 0.6
var time = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mov_speed = default_move_speed

func add_trauma(trauma_amount):
	trauma = clamp(trauma + trauma_amount, 0, 1)

func process_input(delta):
	dir = Vector3()
	var imv = Vector2()
	vel.y = 0
	
	imv.y = Input.get_action_strength("mov_front") - Input.get_action_strength("mov_back")
	imv.x = Input.get_action_strength("mov_right") - Input.get_action_strength("mov_left")
	
	imv = imv.normalized()
	
	dir += -cam.global_transform.basis.z * imv.y
	dir += cam.global_transform.basis.x * imv.x
	if grounded == false:
		vel.y += delta * -24
	vel.x = dir.x
	vel.z = dir.z
	
	move_and_slide(vel * mov_speed)
	
func lean(delta):
	if is_leaning_left:
		rotation_degrees.z = lerp(rotation_degrees.z, 10, delta * 3)
	if is_leaning_right:
		rotation_degrees.z = lerp(rotation_degrees.z, -10, delta * 3)
	if is_leaning_left == false and is_leaning_right == false:
		rotation_degrees.z = lerp(rotation_degrees.z, 0, delta * 3)
	
	if Input.is_action_just_pressed("lean_left"):
		is_leaning_right = false
		is_leaning_left = !is_leaning_left
	if Input.is_action_just_pressed("lean_right"):
		is_leaning_left = false

		is_leaning_right = !is_leaning_right
func crouch(delta):
	if Input.is_action_just_pressed("crouch"):
		if is_crouching == false:
			is_crouching = true
			mov_speed = default_move_speed / 2
			return
		else:
			is_crouching = false
			mov_speed = default_move_speed
			return
			
	if is_crouching == false:
		$BodyCollider.shape.height = lerp(2, 1, delta * 3)
		$BodyCollider.translation.y = lerp(2, 1.5, delta * 3)
		return
	else:
		$BodyCollider.shape.height = lerp(1, 2, delta * 3)
		$BodyCollider.translation.y = lerp(1.5, 2, delta * 3)
		return
	

func _physics_process(delta: float) -> void:
	process_input(delta)
	lean(delta)
	crouch(delta)
	grounded = $BodyCollider/IsOnFloor.is_colliding()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_rot.rotate_x(deg2rad(event.relative.y * .5 * -1))
		self.rotate_y(deg2rad(event.relative.x * 0.5 * -1))
		cam_rot.rotation_degrees.x = clamp(cam_rot.rotation_degrees.x, -70, 70)
