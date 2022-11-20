extends StaticBody2D

export var rumbleAmount:float = 0.5
var rumbling:bool = false

signal carEntered()
signal left()

func _on_Area_body_entered(_body: Node) -> void:
	emit_signal("carEntered")

func _physics_process(_delta:float) -> void:
	if rumbling:
		$Sprite.offset = Vector2(rand_range(-rumbleAmount, rumbleAmount), rand_range(-rumbleAmount, rumbleAmount))

func start(alligator=null):
	$CloseDoor.play()
	$Animation.play("Leave")
	if alligator:
		alligator.hide()
		alligator.canMove = false
		alligator.global_position = global_position

func rumble():
	rumbling = true

func closeDoor():
	$CloseDoor.play()

func _on_Animation_animation_finished(_anim_name: String) -> void:
	emit_signal("left")
