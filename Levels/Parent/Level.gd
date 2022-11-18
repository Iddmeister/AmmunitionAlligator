extends Node2D

class_name Level

export var tracks:PoolStringArray

onready var alligator = $Alligator/Alligator

func _ready() -> void:
	alligator.connect("restart", self, "restart")
	levelStart()

func restart():
	Manager.restartScene()

func levelStart():
	if Manager.playerData.has("clip"):
		alligator.weapon.updateTo(Manager.playerData["clip"], Manager.playerData["ammo"])

func endLevel():
	pass
	
func moveToLevel(path:String, carryAmmo:bool=true):
	if Manager.inTransition:
		return
	if carryAmmo:
		Manager.playerData["ammo"] = alligator.weapon.ammo
		Manager.playerData["clip"] = alligator.weapon.currentClip
	Manager.changeScene(path)
