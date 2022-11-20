extends Level

func levelStart():
	.levelStart()
	$Start/Car.closeDoor()
	Music.playTrack("hunt")
