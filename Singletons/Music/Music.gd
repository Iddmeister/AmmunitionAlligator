extends Node

var allTracks:Dictionary = {
	"ambience":"res://Levels/Level1/Ambience.wav",
	"shatter":"res://Levels/Level2/One Man Symphony - A Wrench In The Works (Free) - 06 Shattering The Illusion (Action 01).mp3",
	}

var loadedTracks:Dictionary = {}
var currentlyPlaying:String

func playTrack(track:String, restart:bool=false):
	if not (track in loadedTracks.keys()):
		loadTrack(track)
	if (not ($Main.stream == loadedTracks[track])) or restart:
		$Main.stream = loadedTracks[track]
		$Main.play()
	currentlyPlaying = track
	
func loadTrack(track:String):
	loadedTracks[track] = load(allTracks[track])