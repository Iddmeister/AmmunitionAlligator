extends Level

var passwordTriggered:bool = false
onready var passwordSpeech: Node2D = $Room1/PasswordSpeech
onready var angrySpeech: Node2D = $Room1/AngrySpeech

func levelStart():
	.levelStart()
	Music.playTrack("iamhere")
	
onready var sword: Node2D = $Trap/Sword

onready var defaultY = sword.get_node("Sprite").global_position.y

func _physics_process(delta: float) -> void:
	sword.get_node("Pivot").global_rotation += delta
	sword.get_node("Sprite").global_position.y = defaultY+sin(OS.get_system_time_msecs()*0.01)*2.5

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

onready var explosion: Node2D = $Trap/Explosion

func _on_TrapTrigger_body_entered(_abody: Node) -> void:
	alligator.camera.shake(70, 1, 200)
	explosion.get_node("Animation").play("Explode")
	Music.stop()
	yield(explosion.get_node("Animation"), "animation_finished")
	Manager.changeScene("res://Levels/Level5/Level5.tscn")
