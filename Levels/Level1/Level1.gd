extends Level

onready var alligator = $Alligator/Alligator

func levelStart():
	.levelStart()
	Music.playTrack("ambience")

func _on_StartSpeech_trigger(code) -> void:
	match code:
		"breakout":
			yield(get_tree().create_timer(1.2), "timeout")
			$StartRoom/RopeTied/RopesBreak.play()
			$StartRoom/Animation.play("Break")
			$StartRoom/InstructionsMove.show()
			alligator.canMove = true
		"bite":
			if not $StartRoom/InstructionsSpit.visible:
				$StartRoom/InstructionsBite.show()


func _on_PhonePig_died() -> void:
	$StartRoom/InstructionsBite.hide()
	$StartRoom/InstructionsSpit.show()
	$StartRoom/PhonePig/Phone.hide()
	
onready var defaultY = $SecondRoom/Revolver.global_position.y

func _physics_process(delta: float) -> void:
	$SecondRoom/Revolver/Pivot.global_rotation += delta
	$SecondRoom/Revolver.global_position.y = defaultY+sin(OS.get_system_time_msecs()*0.01)*2.5

func _on_Revolver_body_entered(_body: Node) -> void:
	if not alligator.hasGun:
		alligator.hasGun = true
		$SecondRoom/Revolver.hide()
		$SecondRoom/Revolver/Pickup.play()
		$SecondRoom/InstructionsShoot.show()
		$SecondRoom/InstructionsReload.show()


func _on_Door2_smashed() -> void:
	$StartRoom/InstructionsBite.show()
	$StartRoom/StartSpeech.show()
	$StartRoom/StartSpeech.queue = [{"text":"Oh Shit", "speed":0.1, "persist":5}]
	$StartRoom/StartSpeech.speak($StartRoom/StartSpeech.queue.front())
	$StartRoom/PhonePig.global_rotation = deg2rad(-90)


func _on_Ladder_body_entered(body: Node) -> void:
	if Manager.inTransition:
		return
	if alligator.hasGun:
		Manager.changeScene("res://Levels/Level2/Level2.tscn")
