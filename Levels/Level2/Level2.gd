extends Level

func levelStart():
	.levelStart()
	if not Music.currentlyPlaying == "shatter":
		Music.playTrack("ambience")

func _on_Door_smashed() -> void:
	Music.playTrack("shatter")
	
onready var defaultY = $Room3/Keys.global_position.y
	
func _physics_process(delta: float) -> void:
	$Room3/Keys/Pivot.global_rotation += delta
	$Room3/Keys.global_position.y = defaultY+sin(OS.get_system_time_msecs()*0.01)*2.5


func _on_OfficeDoor_smashed() -> void:
	$Room3/OfficeSpeech.show()
	$Room3/OfficeSpeech.queue = [{"text":"Who the-", "speed":0.06, "persist":0.15}, {"text":"What are-", "speed":0.06, "persist":0.15}, {"text":"IS THAT AN", "speed":0.05, "persist":0.4}, {"text":"ALLIGATOR!!!", "speed":0.05, "persist":3}]
	$Room3/OfficeSpeech.speak($Room3/OfficeSpeech.queue.front())


func _on_Pig2_died() -> void:
	$Room3/OfficeSpeech.hide()


func _on_Keys_body_entered(body: Node) -> void:
	if $Room3/Keys.visible:
		$Room3/Keys.hide()
		$Room3/Keys/Pickup.play()


func _on_Car_carEntered() -> void:
	if not $Room3/Keys.visible:
		$Room4/Car.start(alligator)


func _on_Car_left() -> void:
	Manager.changeScene("res://Levels/Level3/Level3.tscn")
