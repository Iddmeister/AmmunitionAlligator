extends Level

onready var CinematicCamera = $Start/CinematicCamera

func levelStart():
	.levelStart()
	$RingingEars.play()
	
func _ready() -> void:
	alligator.camera.current = false
	CinematicCamera.make_current()

onready var elephantSpeech: Node2D = $Start/Speech
onready var chipSpeech: Node2D = $Start/Chip

var laugh = "[shake rate=10 level=20]hehehehehe[/shake]"


func startSpeech():
	Music.playTrack("hideout")
	elephantSpeech.show()
	elephantSpeech.queue = [
		
		{"text":"Rise and shine", "speed":0.1, "persist":0.6},
		{"text":"Had a nice nap?", "speed":0.1, "persist":0.6},
		{"text":laugh, "speed":0.1, "persist":1.5},
		{"text":"Don't move around", "speed":0.1, "persist":0.3},
		{"text":"too much", "speed":0.1, "persist":0.5},
		{"text":"You might catch", "speed":0.1, "persist":0.3},
		{"text":"a bullet", "speed":0.1, "persist":1},
		{"text":laugh, "speed":0.1, "persist":1.5, "trigger":"bullet"},
		{"text":"GET OUT", "speed":0.05, "persist":2, "trigger":"shutup"},
		{"text":"You're quite", "speed":0.1, "persist":0.6},
		{"text":"the specimen", "speed":0.1, "persist":1},
		{"text":"lots of teeth", "speed":0.1, "persist":0.6},
		{"text":"[shake rate=10 level=20]hehe[/shake]", "speed":0.1, "persist":0.8},
		{"text":"I would love to", "speed":0.1, "persist":0.6},
		{"text":"keep you", "speed":0.1, "persist":1},
		{"text":"but you seem to", "speed":0.1, "persist":0.6},
		{"text":"be more trouble", "speed":0.1, "persist":0.6},
		{"text":"than you're worth", "speed":0.1, "persist":1.3},
		{"text":"death it is", "speed":0.1, "persist":0.6},
		{"text":"unfortunate I know", "speed":0.1, "persist":0.6},
		{"text":laugh, "speed":0.1, "persist":1.5},
		{"text":"how about", "speed":0.1, "persist":0.6},
		{"text":"a toast", "speed":0.1, "persist":0.6},
		{"text":"to you", "speed":0.1, "persist":2},
		{"text":"drink up", "speed":0.1, "persist":1.2, "trigger":"drink"},
		{"text":laugh, "speed":0.1, "persist":1.5},
		
	]
	
	elephantSpeech.speak(elephantSpeech.queue.front())
	


func _on_Speech_trigger(code) -> void:
	match code:
		"bullet":
			chipSpeech.show()
			chipSpeech.queue = [{"text":"Good one Boss", "speed":0.05, "persist":1}]
			chipSpeech.speak(chipSpeech.queue.front())
		"shutup":
			chipSpeech.hide()
			for p in range(1, 4):
				var pig = $Start.get_node("Pig%s" % p)
				pig.navAgent.set_target_location($Start/Exit.global_position)
				pig.moving = true
				pig.connect("reachedDestination", pig, "queue_free")
		"drink":
			$Start/Animation.play("Slide")
			yield($Start/Animation, "animation_finished")
			alligator.camera.make_current()
			$ThinkingTime.start()


func _on_Elephant_died() -> void:
	elephantSpeech.hide()
	alligator.canMove = true
	Music.playTrack("notlikethis")
	$Start/InstructionsBite.hide()
	$Start/InstructionsSpit.hide()


func _on_ExitTrigger_body_entered(_body: Node) -> void:
	Manager.changeScene("res://Levels/Level6/Level6.tscn")


func _on_ThinkingTime_timeout() -> void:
	if not $Start/Elephant.dead:
		$Start/InstructionsBite.show()

func _on_SpecialEthanol_destroyed() -> void:
	if $ThinkingTime.is_stopped():
		$Start/InstructionsBite.hide()
		$Start/InstructionsSpit.show()
