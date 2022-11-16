extends Node2D

signal finished()
signal trigger(code)

var queue:Array

export var speech:Array

func _ready() -> void:
	if not speech.empty():
		queue = speech
		speak(queue.front())
	
func _physics_process(delta: float) -> void:
	global_rotation = 0
	
func speak(speech:Dictionary):
	
	$Back/Text.visible_characters = 0
	$Back/Text.bbcode_text = "[center]"+speech.text+"[/center]"
	$Speed.start(speech.speed)
	
func _on_Speed_timeout() -> void:
	$Back/Text.visible_characters = int(min($Back/Text.visible_characters+1, $Back/Text.text.length()))
	if $Back/Text.visible_characters >= $Back/Text.text.length():
		$Speed.stop()
		$Spoke.start(queue.front().persist if queue.front().has("persist") else 0)
		if queue.front().has("trigger"):
			emit_signal("trigger", queue.front().trigger)

func _on_Spoke_timeout() -> void:
	var prev = queue.pop_front()
	if not queue.empty():
		speak(queue[0])
	else:
		if prev.has("hide"):
			hide()
		emit_signal("finished")
