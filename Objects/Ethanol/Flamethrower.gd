extends Area2D

export var spread:float = 30
export var firerate:float = 0.005
onready var fireTime:float = 0

var Flame = preload("res://Objects/Ethanol/Flame.tscn")

signal finished()

func _ready() -> void:
	$Ignite.play()
	$Flames.play()
	connect("finished", get_parent().get_parent(), "flamesFinished")
	
func _physics_process(delta: float) -> void:
	
	if fireTime <= 0:
		shoot()
		fireTime = firerate
	fireTime -= delta

func _on_Flamethrower_body_entered(body: Node) -> void:
	if body.has_method("ignite"):
		body.ignite()
		
func shoot():
	var f = Flame.instance()
	get_parent().get_parent().get_parent().add_child(f)
	f.global_position = get_parent().global_position
	f.speed *= rand_range(1, 1.5)
	f.global_rotation = global_rotation


func _on_Time_timeout() -> void:
	emit_signal("finished")
	queue_free()
