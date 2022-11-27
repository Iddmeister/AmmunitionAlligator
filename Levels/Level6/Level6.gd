extends Level

func _ready() -> void:
	Music.playTrack("notlikethis")
	
onready var revolver: Area2D = $Room5/Revolver

onready var defaultY = revolver.get_node("Sprite").global_position.y

func _physics_process(delta: float) -> void:
	revolver.get_node("Pivot").global_rotation += delta
	revolver.get_node("Sprite").global_position.y = defaultY+sin(OS.get_system_time_msecs()*0.01)*2.5


func _on_Revolver_body_entered(_body: Node) -> void:
	if alligator.hasGun:
		return
	revolver.get_node("Pickup").play()
	revolver.hide()
	alligator.hasGun = true
	
	
onready var cinematic_camera: Camera2D = $End/CinematicCamera

onready var endSpeech: Node2D = $End/EndSpeech


func _on_EndDoor_smashed() -> void:
	alligator.invincible = true
	$End/Animation.play("Reveal")
	alligator.canMove = false
	alligator.canAct = false
	get_tree().set_group("Pig", "aggressive", false)
	get_tree().set_group("Tortoise", "aggressive", false)
	cinematic_camera.make_current()
	Music.stop()
	create_tween().tween_property(alligator, "global_position", $End/Alligator.global_position, 1)
	create_tween().tween_property(alligator, "global_rotation", deg2rad(90), 0.5)
	$DramaticPause.start()


func _on_DramaticPause_timeout() -> void:
	Music.playTrack("neverknow")
	endSpeech.show()
	endSpeech.queue = [
		{"text":"End of the road", "speed":0.1, "persist":2},
		{"text":"Good luck getting", "speed":0.1, "persist":0.6},
		{"text":"out of this one", "speed":0.1, "persist":2, "trigger":"end"},
	]
	endSpeech.speak(endSpeech.queue.front())


func _on_EndSpeech_trigger(_code) -> void:
	$End/Animation.play("Death")
	yield($End/Animation, "animation_finished")
	var t = create_tween()
	t.tween_property(alligator, "global_position", $End/Exit.global_position, 5)
	t.tween_callback(self, "end")
	alligator.get_node("Graphics/Legs").global_rotation = 0
	alligator.cutsceneMove = true
	
var Blood = preload("res://Blood/Blood.tscn")
	
func killEveryone():
	for obj in $End/Enemies.get_children():
		var b = Blood.instance()
		add_child(b)
		b.global_position = obj.global_position
		obj.queue_free()
		
func end():
	Manager.changeScene("res://Screens/EndScreen/EndScreen.tscn")
		
