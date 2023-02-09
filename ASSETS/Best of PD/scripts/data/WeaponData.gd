extends Resource
class_name Weapon_Data

export var mag_size : int = 10
export var mags : int = 3
export var reload_time : float = 3
export var shoot_delay : float = 0.1
export var damage : float = 2
export var vertical_recoil : float = 0.6

export var weapon_name : String

enum FIRE_TYPE {
	semi,
	auto
}

export (FIRE_TYPE) var fire_type
