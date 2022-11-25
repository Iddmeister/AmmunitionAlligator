extends Node

var allTracks:Dictionary = {
	"ambience":"res://Levels/Level1/Ambience.wav",
	"shatter":"res://Levels/Level2/One Man Symphony - A Wrench In The Works (Free) - 06 Shattering The Illusion (Action 01).mp3",
	"hunt":"res://Levels/Level3/One Man Symphony - A Wrench In The Works (Free) - 04 You Took Something Very Valuable From Me (Chase Theme 01).mp3",
	"iamhere":"res://Levels/Level4/One Man Symphony - A Wrench In The Works (Free) - 07 I Want Them To Know That... I Am Here (Action 02).mp3",
	"hideout":"res://Levels/Level5/One Man Symphony - A Wrench In The Works (Free) - 02 Unknown (Hideout Theme).mp3",
	"notlikethis":"res://Levels/Level5/One Man Symphony - A Wrench In The Works (Free) - 08 I Wasn't Always Like This (Action 03).mp3",
	}

var loadedTracks:Dictionary = {}
var currentlyPlaying:String

func stop():
	$Main.stop()

func playTrack(track:String, restart:bool=false):
	if not (track in loadedTracks.keys()):
		loadTrack(track)
	if (not ($Main.stream == loadedTracks[track])) or restart:
		$Main.stream = loadedTracks[track]
		$Main.play()
	currentlyPlaying = track
	
func loadTrack(track:String):
	loadedTracks[track] = load(allTracks[track])
