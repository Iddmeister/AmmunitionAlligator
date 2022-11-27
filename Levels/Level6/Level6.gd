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
	$End/Animation.play("Reveal")
	alligator.canMove = false
	alligator.canAct = false
	get_tree().set_group("Pig", "aggressive", false)
	get_tree().set_group("Tortoise", "aggressive", false)
	cinematic_camera.make_current()
