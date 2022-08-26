extends Spatial

export var mag_size : int = 10
export var starting_mags : int = 3
export var shoot_time : NodePath
export var reload_time : NodePath
export var sound : NodePath
export var particles_spawn_pos : NodePath
export var particles : PackedScene
export var recoil : float = 3
export var accuracy_normal : float = 5
export var accuracy_aiming : float = 1

export var sight : NodePath
export var light : NodePath

var current_mags : int
var ammo_in_mag : int

var can_shoot : bool = true
var is_reloading : bool = false

var is_aiming : bool = false

signal shot

func _ready() -> void:
	ammo_in_mag = mag_size
	current_mags = starting_mags
	get_node(shoot_time).connect("timeout", self, "reset_shoot")
	get_node(reload_time).connect("timeout", self, "reload")
	if get_node(reload_time).one_shot == false:
		get_node(reload_time).one_shot = true

func _process(delta: float) -> void:
	API.ammo_label.text = str(ammo_in_mag)
	API.mags_label.text = str(current_mags)
	
	translation.z = lerp(translation.z, 0, delta * 3)
	rotation_degrees.x = lerp(rotation_degrees.x, 0, delta * 3)
	
	if ammo_in_mag <= 0 and current_mags <= 0:
		return

	if Input.is_action_pressed("shoot"):
		if can_shoot and ammo_in_mag > 0:
			shoot()
	if ammo_in_mag <= 0 and current_mags > 0 and is_reloading == false:
		get_node(reload_time).start()
		is_reloading = true
	
	if Input.is_action_just_pressed("aim"):
		is_aiming = !is_aiming
	aim(delta)

func shoot():
	ammo_in_mag -= 1
	can_shoot = false
	get_node(shoot_time).start()
	translation.z += recoil / 10
	rotation_degrees.x += recoil
	get_node(sound).play()
	
	var p : Particles = particles.instance()
	get_tree().get_current_scene().add_child(p)
	p.global_transform = get_node(particles_spawn_pos).global_transform
	
	if is_aiming == true:
		API.shoot_cast.rotation_degrees.y = rand_range(-accuracy_aiming, accuracy_aiming)
		API.shoot_cast.rotation_degrees.x = rand_range(-accuracy_aiming, accuracy_aiming)
	else:
		API.shoot_cast.rotation_degrees.y = rand_range(-accuracy_normal, accuracy_normal)
		API.shoot_cast.rotation_degrees.x = rand_range(-accuracy_normal, accuracy_normal)

func enable_light():
	if light != "":
		get_node(light).light()

func reset_shoot():
	can_shoot = true

func reload():
	ammo_in_mag = mag_size
	current_mags -= 1
	is_reloading = false

func aim(delta):
	if is_aiming == true:
		API.cam.fov = lerp(API.cam.fov, 50, delta * 10)
		API.weapon_library.translation = lerp(API.weapon_library.translation, API.aim_position.translation, delta * 10)
	if is_aiming == false:
		API.cam.fov = lerp(API.cam.fov, 90, delta * 10)
		API.weapon_library.translation = lerp(API.weapon_library.translation, Vector3(0.989, 0, -1.573), delta * 10)
