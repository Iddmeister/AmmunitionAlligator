extends Level

var passwordTriggered:bool = false
onready var passwordSpeech: Node2D = $Room1/PasswordSpeech
onready var angrySpeech: Node2D = $Room1/AngrySpeech

func levelStart():
	.levelStart()
	Music.playTrack("iamhere")

func _on_PasswordTrigger_body_entered(_body: Node) -> void:
	if passwordTriggered:
		return
	passwordTriggered = true
	passwordSpeech.show()
	passwordSpeech.queue = [{"text":"What's the", "speed":0.1, "persist":0.6}, {"text":"password?", "speed":0.1, "persist":5}]
	passwordSpeech.speak(passwordSpeech.queue.front())
	


func _on_Entrance_smashed() -> void:
	passwordSpeech.hide()
	angrySpeech.show()
	angrySpeech.queue = [{"text":"THAT'S NOT", "speed":0.05, "persist":0.6}, {"text":"THE PASSWORD", "speed":0.05, "persist":2}]
	angrySpeech.speak(angrySpeech.queue.front())


func _on_AngryPig_died() -> void:
	angrySpeech.hide()
