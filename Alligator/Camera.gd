extends Camera2D

var currentImportance:int = 0

var moving:bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("look"):
		position = Vector2(200, 0)
	else:
		position = Vector2(0, 0)

func move_camera(move:Vector2):
	if not moving:
		offset = Vector2(rand_range(-move.x, move.x), rand_range(-move.y, move.y))
	pass
	
func shake(power:float, time:float, importance:int=0):
	
	if importance >= currentImportance:
		currentImportance = importance
	else:
		return
	
	$Tween.interpolate_method(self, "move_camera", Vector2(power, power), Vector2(0, 0), time, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
	$Tween.start()
	
	pass


func _on_Tween_tween_completed(_object, _key):
	currentImportance = 0
