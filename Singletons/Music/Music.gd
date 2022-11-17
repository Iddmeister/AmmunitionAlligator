extends Node

var allTracks:Dictionary = {"ambience":"res://Levels/Level1/Ambience.wav"}

var loadedTracks:Dictionary = {}

func playTrack(track:String):
	if not (track in loadedTracks.keys()):
		loadTrack(track)
	$Main.stream = loadedTracks[track]
	$Main.play()
	
func loadTrack(track:String):
	loadedTracks[track] = load(allTracks[track])
