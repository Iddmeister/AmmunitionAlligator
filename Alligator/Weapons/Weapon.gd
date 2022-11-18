extends Node2D

class_name Weapon

export var clipSize:int = 6
export var ammo:int = 18
onready var currentClip:int = clipSize
var reloadAmmo:int
var reloading:bool = false

var alligator

func _ready() -> void:
	$UI/HBoxContainer/Ammo.text = "%s" % currentClip
	$UI/HBoxContainer/MaxAmmo.text = " |%s" % ammo

func attack(_pos:Vector2):
	pass
	
func updateTo(clip:int, _ammo:int):
	currentClip = clip
	ammo = _ammo
	$UI/HBoxContainer/MaxAmmo.text = " |%s" % ammo
	$UI/HBoxContainer/Ammo.text = "%s" % currentClip
	
func addAmmo(amount:int=clipSize):
	ammo += amount
	$UI/HBoxContainer/MaxAmmo.text = " |%s" % ammo
	$PickupAmmo.pitch_scale = 1+rand_range(0, 0.2)
	$PickupAmmo.play()
	if currentClip <= 0 and ammo > 0:
		reload()

func useAmmo(amount:int=1):
	currentClip -= amount
	$UI/HBoxContainer/Ammo.text = "%s" % currentClip
	if currentClip <= 0:
		currentClip = 0
		reload()
		
func reload():
	if not ammo > 0 or currentClip == clipSize or reloading:
		return false
	ammo -= (clipSize-currentClip)
	reloadAmmo = int(clipSize-abs(ammo)) if ammo < 0 else clipSize
	ammo = int(max(0, ammo))
	$UI/HBoxContainer/MaxAmmo.text = " |%s" % ammo
	reloading = true
	return true
	
func finishReload():
	currentClip = reloadAmmo
	reloadAmmo = 0
	$UI/HBoxContainer/Ammo.text = "%s" % currentClip
	reloading = false
	
func hide():
	$UI/HBoxContainer.hide()
	.hide()
	
func show():
	$UI/HBoxContainer.show()
	.show()
