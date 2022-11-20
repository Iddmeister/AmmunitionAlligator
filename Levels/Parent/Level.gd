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
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if not $Pause/Pause.visible:
			$Pause/Pause.show()
			get_tree().paused = true
		else:
			$Pause/Pause.hide()
			get_tree().paused = false


func _on_Resume_pressed() -> void:
	$Pause/Pause.hide()
	get_tree().paused = false

func _on_Restart_pressed() -> void:
	$Pause/Pause.hide()
	restart()

func _on_Options_pressed() -> void:
	$Pause/Options.show()

func _on_Menu_pressed() -> void:
	$Pause/Pause.hide()
	Manager.changeScene("res://Screens/Main/Main.tscn")
