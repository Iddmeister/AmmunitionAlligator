extends Node2D

func speak(text:String):
	$Back/Text.bbcode_text = "[center]"+text+"[/center]"
	$Speed.start()
	

func _on_Speed_timeout() -> void:
	$Back/Text.visible_characters = int(min($Back/Text.visible_characters+1, $Back/Text.text.length()))
