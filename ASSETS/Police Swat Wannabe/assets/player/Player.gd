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
var is_sprinting : bool = false
var stamina : float = 2.0
var freelook : bool = false

onready var cam = $CameraHolder/Camera

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mov_speed = default_move_speed
	API.shoot_cast = $CameraHolder/Camera/ShootCast
	API.cam = cam
	API.weapon_library = $CameraHolder/Weapons
	API.aim_position = $CameraHolder/AimPosition

func process_input(delta):
	dir = Vector3()
	var imv = Vector2()
	vel.y = 0
	
	imv.y = Input.get_action_strength("mov_front") - Input.get_action_strength("mov_back")
	imv.x = Input.get_action_strength("mov_right") - Input.get_action_strength("mov_left")
	move_and_tilt(imv, delta)
	weapon_move(imv, delta)
	
	imv = imv.normalized()
	
	dir += -cam.global_transform.basis.z * imv.y
	dir += cam.global_transform.basis.x * imv.x
	if grounded == false:
		vel.y += delta * -24
	vel.x = dir.x
	vel.z = dir.z
	
	move_and_slide(vel * mov_speed)

func move_and_tilt(imv, delta):
	cam.rotate_x(-imv.y * 0.01)
	cam.rotate_z(-imv.x * 0.01)
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -1, 1)
	cam.rotation_degrees.z = clamp(cam.rotation_degrees.z, -1, 1)
	cam.rotation_degrees.x = lerp(cam.rotation_degrees.x, 0, delta * 3)
	cam.rotation_degrees.z = lerp(cam.rotation_degrees.z, 0, delta * 3)
	
func weapon_move(imv, delta):
	
	for weapon in $CameraHolder/Weapons.get_children():
		if weapon.is_aiming == false:
			$CameraHolder/Weapons.translation.x = lerp($CameraHolder/Weapons.translation.x, imv.x * 0.1 + 0.989, delta * 10)
			$CameraHolder/Weapons.translation.z = lerp($CameraHolder/Weapons.translation.z, imv.y * 0.1 + -1.573, delta * 10)
	
func lean(delta):
	if is_leaning_left:
		rotation_degrees.z = lerp(rotation_degrees.z, 15, delta * 5)
	if is_leaning_right:
		rotation_degrees.z = lerp(rotation_degrees.z, -15, delta * 5)
	if is_leaning_left == false and is_leaning_right == false:
		rotation_degrees.z = lerp(rotation_degrees.z, 0, delta * 5)
	
	if Input.is_action_just_pressed("lean_left"):
		is_leaning_right = false
		is_leaning_left = !is_leaning_left
	if Input.is_action_just_pressed("lean_right"):
		is_leaning_left = false
		is_leaning_right = !is_leaning_right

func crouch(delta):
	if is_crouching == true:
		$BodyCollider.shape.height = lerp($BodyCollider.shape.height, 0.5, delta * 5)
		$BodyCollider.translation.y = 1.3
	if is_crouching == false:
		$BodyCollider.shape.height = lerp($BodyCollider.shape.height, 4, delta * 5)
		$BodyCollider.translation.y = 2
	if Input.is_action_just_pressed("crouch"):
		is_crouching = !is_crouching

func sprint():
	if stamina >= 1:
		if Input.is_action_pressed("sprint"):
			mov_speed = sprint_mov_speed
			is_sprinting = true
	if Input.is_action_pressed("sprint") == false or stamina < 1:
		mov_speed = default_move_speed
		is_sprinting = false

func stamina(delta):
	if is_sprinting:
		stamina -= delta
	if is_sprinting == false and stamina <= 5:
		stamina += delta

func _physics_process(delta: float) -> void:
	process_input(delta)
	lean(delta)
	crouch(delta)
	stamina(delta)
	sprint()
	grounded = $IsOnFloor.is_colliding()
	$CameraHolder.rotation_degrees.x = clamp($CameraHolder.rotation_degrees.x, -60, 60)
	if Input.is_action_just_pressed("enable_light"):
		for gun in API.weapon_library.get_children():
			gun.enable_light()
	freelook = Input.is_action_pressed("freelook")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if freelook == false:
			$CameraHolder.rotate_x(deg2rad(event.relative.y * .5 * -1))
			self.rotate_y(deg2rad(event.relative.x * 0.5 * -1))
		else:
			cam.rotate_x(deg2rad(event.relative.y * .5 * -1))
			cam.rotate_y(deg2rad(event.relative.x * 0.5 * -1))
