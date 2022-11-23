extends Level

func levelStart():
	.levelStart()
	$Start/Car.closeDoor()
	Music.playTrack("hunt")


func _on_Pig_died() -> void:
	$Bathroom/Bath/Animation.play("Bloody")
	$Bathroom/Speech.hide()


func _on_Door_smashed() -> void:
	$Bathroom/Speech.show()
	$Bathroom/Speech.queue = [{"text":"wtf-", "speed":0.01, "persist":0.2}, {"text":"ALLIGATOR!!", "speed":0.01, "persist":1}, {"text":"They weren't", "speed":0.1, "persist":0.5}, {"text":"Kidding!?", "speed":0.1, "persist":3}, {"text":"er", "speed":0.1, "persist":1}, {"text":"Could you leave?", "speed":0.1, "persist":2}, {"text":"please", "speed":0.05, "persist":5}]
	$Bathroom/Speech.speak($Bathroom/Speech.queue.front())

var spoken:bool = false

func _on_Trigger_body_entered(_body: Node) -> void:
	if spoken:
		return
	spoken = true
	$Start/Speech.show()
	$Start/Speech.queue = [{"text":"you-", "speed":0.1, "persist":2}, {"text":"can't", "speed":0.1, "persist":2}, {"text":"not possi-", "speed":0.2, "persist":2}, {"text":"extinct", "speed":0.3, "persist":3}]
	$Start/Speech.speak($Start/Speech.queue.front())


func _on_Speech_finished() -> void:
	$Start/Speech.hide()
	
onready var askSpeech: Node2D = $Room4/Asker
onready var answerSpeech: Node2D = $Room4/Answer

var mentionedEnvelope:bool = false

func _on_EnvelopeDoor_smashed() -> void:
	askSpeech.show()
	askSpeech.queue = [{"text":"Any idea where", "speed":0.1, "persist":1}, {"text":"Boss went?", "speed":0.1, "persist":2}]
	askSpeech.speak(askSpeech.queue.front())
	yield(get_tree().create_timer(4), "timeout")
	if $Room4/InterruptDoor.knocked:
		return
	answerSpeech.show()
	answerSpeech.queue = [{"text":"He said to open", "speed":0.1, "persist":1, "trigger":"envelope"}, {"text":"that envelope", "speed":0.1, "persist":1}, {"text":"if we need him", "speed":0.1, "persist":3}]
	answerSpeech.speak(answerSpeech.queue.front())


func _on_InterruptDoor_smashed() -> void:
	answerSpeech.hide()
	if mentionedEnvelope:
		askSpeech.queue = [{"text":"OPEN IT!!!", "speed":0.05, "persist":2}]
		askSpeech.speak(askSpeech.queue.front())
	else:
		askSpeech.queue = [{"text":"is that?", "speed":0.05, "persist":0.6}, {"text":"ALLIGATOR", "speed":0.05, "persist":2}]
		askSpeech.speak(askSpeech.queue.front())


func _on_Speech2_trigger(_code) -> void:
	mentionedEnvelope = true


func _on_Pig2_died() -> void:
	askSpeech.hide()
	
onready var defaultY = $Room4/Envelope/Sprite.global_position.y
onready var defaultY2 = $Office/Password/Sprite.global_position.y
	
func _physics_process(delta: float) -> void:
	$Room4/Envelope/Pivot.global_rotation += delta
	$Office/Password/Pivot.global_rotation += delta
	$Room4/Envelope/Sprite.global_position.y = defaultY+sin(OS.get_system_time_msecs()*0.01)*2.5
	$Office/Password/Sprite.global_position.y = defaultY2+sin(OS.get_system_time_msecs()*0.01)*2.5


onready var envelopeText = $Envelopes/Envelope/MarginContainer/Text


func _on_Envelope_body_entered(_body: Node) -> void:
	if not $Room4/Envelope.visible:
		return
	$Envelopes/Open.play()
	$Room4/Envelope.hide()
	envelopeText.get_parent().get_parent().show()
	if not $Office/Password.visible:
		envelopeText.text = "17 Greenwood Road, give password at door (Blue Scrofa)"
		$Envelopes/Leave.show()
	else:
		envelopeText.text = "17 Greenwood Road, give password at door"
	


func _on_Password_body_entered(_body: Node) -> void:
	if not $Office/Password.visible:
		return
	$Envelopes/Open.play()
	$Office/Password.hide()
	envelopeText.get_parent().get_parent().show()
	if not $Room4/Envelope.visible:
		envelopeText.text = "17 Greenwood Road, give password at door (Blue Scrofa)"
		$Envelopes/Leave.show()
	else:
		envelopeText.text = "Password - Blue Scrofa"


func _on_Car_carEntered() -> void:
	if (not $Office/Password.visible) and (not $Room4/Envelope.visible):
		$Start/Car.startCar(alligator)
		envelopeText.get_parent().get_parent().hide()
		$Envelopes/Leave.hide()
		Music.stop()


func _on_Car_left() -> void:
	Manager.changeScene("res://Levels/Level4/Level4.tscn")
