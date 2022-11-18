extends Level

func levelStart():
	.levelStart()
	if not Music.currentlyPlaying == "shatter":
		Music.playTrack("ambience")

func _on_Door_smashed() -> void:
	Music.playTrack("shatter")
