extends Node

var _player_fov : float = 70.0
var _player_default_move_speed : float = 4.0
var _player_crouch_move_speed : float = 2.0
var _player_lean_angle : float = 10.0

var _body_cam_police_department : String = "Bowtown"
var _body_cam_manufacturer : String = "JeezPro AE94"
var _body_cam_text_color : Color = Color(247, 255, 0, 255)

func _ready() -> void:
	var dir = Directory.new()
	if dir.dir_exists("configs") == false:
		dir.make_dir("configs")
	
	var f = File.new()
	var cfg = ConfigFile.new()
	if f.file_exists("configs/config.cfg") == true:
		cfg.load("configs/config.cfg")
		_player_fov = cfg.get_value("Player", "player_fov")
		_player_default_move_speed = cfg.get_value("Player", "player_default_move_speed")
		_player_crouch_move_speed  = cfg.get_value("Player", "player_crouch_move_speed")
		_player_lean_angle = cfg.get_value("Player", "player_lean_angle")
		
		_body_cam_manufacturer = cfg.get_value("Bodycam", "body_cam_manufacturer")
		_body_cam_police_department = cfg.get_value("Bodycam", "body_cam_police_department")
		_body_cam_text_color = cfg.get_value("Bodycam", "body_cam_text_color")
	else:
		cfg.set_value("Player", "player_fov", _player_fov)
		cfg.set_value("Player", "player_default_move_speed", _player_default_move_speed)
		cfg.set_value("Player", "player_crouch_move_speed", _player_crouch_move_speed)
		cfg.set_value("Player", "player_lean_angle", _player_lean_angle)
		
		cfg.set_value("Bodycam", "body_cam_manufacturer", _body_cam_manufacturer)
		cfg.set_value("Bodycam", "body_cam_police_department", _body_cam_police_department)
		cfg.set_value("Bodycam", "body_cam_text_color", _body_cam_text_color)
		
		cfg.save("configs/config.cfg")
