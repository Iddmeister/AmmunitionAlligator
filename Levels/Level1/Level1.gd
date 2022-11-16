extends Level

onready var alligator = $Alligator/Alligator

func levelStart():
	.levelStart()
	


func _on_StartSpeech_trigger(code) -> void:
	match code:
		"breakout":
			$StartRoom/RopeTied/RopesBreak.play()
			$StartRoom/Animation.play("Break")
			alligator.canMove = true
