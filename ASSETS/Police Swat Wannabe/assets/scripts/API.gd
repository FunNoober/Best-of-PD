extends Node

var shoot_cast : RayCast
var ui : Control
var ammo_label : Label
var mags_label : Label
var cam : Camera
var weapon_library : Spatial
var aim_position : Spatial
var player : Spatial
var global_delta : float

func _process(delta: float) -> void:
	global_delta = delta
