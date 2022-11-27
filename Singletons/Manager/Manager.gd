extends Node

export var cursorOpen:Texture
export var cursorClosed:Texture
var cursorIsOpen:bool = true

signal changedScene()
signal changedSceneVisible()

onready var animation: AnimationPlayer = $Layer/Animation

var playerData:Dictionary
var lives:bool = false

var inTransition:bool = false

func _on_CursorBite_timeout() -> void:
	Input.set_custom_mouse_cursor(cursorOpen if cursorIsOpen else cursorClosed, Input.CURSOR_ARROW, Vector2(16, 16))
	cursorIsOpen = not cursorIsOpen


func restartScene():
	changeScene($Scene.get_child(0).filename)
	
func clearScene():
	if $Scene.get_child_count() > 0:
		$Scene.get_child(0).free()
	
func changeScene(path:String):
	
	inTransition = true
	$Layer/Animation.play("Close")
	yield($Layer/Animation, "animation_finished")
	get_tree().paused = true
	
	clearScene()
	
	var s = load(path).instance()
	
	var tracks:PoolStringArray = []
	
	if s.is_in_group("MusicLoader"):
		tracks = s.tracks
		
	for loadedTrack in Music.loadedTracks.keys():
		if not (loadedTrack in tracks):
			Music.loadedTracks.erase(loadedTrack)
	for track in tracks:
		if not (track in Music.loadedTracks.keys()):
			Music.loadTrack(track)
	
	$Scene.add_child(s)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	get_tree().paused = false
	emit_signal("changedScene")
	$Layer/Animation.play("Open")
	inTransition = false
	yield($Layer/Animation, "animation_finished")
	emit_signal("changedSceneVisible")
	
