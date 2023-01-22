extends Spatial

export var data : Resource
onready var ammo_in_mag = data.mag_size
onready var mag_count = data.mags
var can_shoot : bool = true

func _ready() -> void:
	$ShootTimer.connect("timeout", self, "reset_shoot")
	$ReloadTimer.connect("timeout", self, "reset_mag")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload") and mag_count > 1:
		$ReloadTimer.start(data.reload_time)
	
	if can_shoot:
		if data.fire_type == data.FIRE_TYPE.auto:
			if Input.is_action_pressed("shoot"):
				shoot()
		if data.fire_type == data.FIRE_TYPE.semi:
			if Input.is_action_just_pressed("shoot"):
				shoot()
	
func shoot():
	can_shoot = false
	$ShootTimer.start(data.shoot_delay)
	
func reset_shoot():
	can_shoot = true
	
func reset_mag():
	mag_count -= 1
	ammo_in_mag = data.mag_size
