extends KinematicBody

var vel = Vector3()
var dir = Vector3()

var default_move_speed : float = 4.0

var mov_speed : float = 4
var crouch_mov_speed : float = 2
var lean_angle : float = 10
var grounded : bool = true
var is_leaning_left : bool = false
var is_leaning_right : bool = false
var is_crouching : bool = false

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

onready var cam = $BodyCollider/CamRot/Camera
onready var cam_rot = $BodyCollider/CamRot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mov_speed = default_move_speed
	for i in $BodyCollider/CamRot/Camera/Weapons.get_children():
		i.connect("shot", self, "shot")
		
	$BodyCollider/CamRot/Camera.fov = Init._player_fov
	default_move_speed = Init._player_default_move_speed
	crouch_mov_speed = Init._player_crouch_move_speed
	lean_angle = Init._player_lean_angle
	mov_speed = default_move_speed
	
	$UI/UIControl/BodyCamLabel.text = "Police of " + Init._body_cam_police_department + "\n" + Init._body_cam_manufacturer
	$UI/UIControl/BodyCamLabel.set("custom_colors/font_color", Init._body_cam_text_color)
	
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
	shake(0.01, 0.1)
	
func lean(delta):
	if is_leaning_left:
		rotation_degrees.z = lerp(rotation_degrees.z, lean_angle, delta * 3)
	if is_leaning_right:
		rotation_degrees.z = lerp(rotation_degrees.z, -lean_angle, delta * 3)
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
			mov_speed = crouch_mov_speed
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
	camera_shake_duration = camera_shake_duration - delta
	cam.rotation_degrees.y += sin(OS.get_ticks_msec() * 0.03) * 0.07 * camera_shake_intensity
	cam.rotation_degrees.x += sin(OS.get_ticks_msec() * 0.05) * 0.07 * camera_shake_intensity
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cam_rot.rotate_x(deg2rad(event.relative.y * .5 * -1))
		self.rotate_y(deg2rad(event.relative.x * 0.5 * -1))
		cam_rot.rotation_degrees.x = clamp(cam_rot.rotation_degrees.x, -70, 70)

func shot(vertical_recoil):
	rotation_degrees.x += vertical_recoil
	shake(0.1, 2)

func shake(duration, intensity):
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
	
	if camera_shake_duration <= 0:
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
