extends Spatial

signal shot(recoil)

export var data : Resource
var ammo_in_mag
var mag_count
var can_shoot : bool = true

func _ready() -> void:
	$ShootTimer.connect("timeout", self, "reset_shoot")
	$ReloadTimer.connect("timeout", self, "reset_mag")
	save()
	mag_count = data.mags
	ammo_in_mag = data.mag_size
	
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
	$"Si P230/AnimationPlayer".play("Shoot2")
	emit_signal("shot", data.vertical_recoil)
	
	if $ShootCast.is_colliding() and $ShootCast.get_collider().is_in_group("NPC"):
		$ShootCast.get_collider().cur_health -= data.damage
	
func reset_shoot():
	can_shoot = true
	
func reset_mag():
	mag_count -= 1
	ammo_in_mag = data.mag_size

func save():
	var f = File.new()
	var cfg = ConfigFile.new()
	
	if f.file_exists("configs/" + data.weapon_name + ".cfg") == true:
		cfg.load("configs/" + data.weapon_name + ".cfg")
		data.mag_size = cfg.get_value("Weapon", "mag_size")
		data.mags = cfg.get_value("Weapon", "mags")
		data.reload_time = cfg.get_value("Weapon", "reload_time")
		data.shoot_delay = cfg.get_value("Weapon", "shoot_delay")
		data.damage = cfg.get_value("Weapon", "damage")
	else:
		cfg.set_value("Weapon", "mag_size", data.mag_size)
		cfg.set_value("Weapon", "mags", data.mags)
		cfg.set_value("Weapon", "reload_time", data.reload_time)
		cfg.set_value("Weapon", "shoot_delay", data.shoot_delay)
		cfg.set_value("Weapon", "damage", data.damage)
		cfg.save("configs/" + data.weapon_name + ".cfg")
