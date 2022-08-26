extends Control

func _ready() -> void:
	API.ui = self
	API.ammo_label = $AmmoUserInterface/AmmoInMagLabel
	API.mags_label = $AmmoUserInterface/MagsLabel
