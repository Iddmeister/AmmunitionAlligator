extends Area2D

export var spread:float = 30
export var distance:float = 200
export var pointVariance:float = 5
export var numPoints:int = 50

var Flame = preload("res://Objects/Ethanol/Flame.tscn")

var smokeRadii := []
onready var lastRot:float = global_rotation

func _ready() -> void:
	$Ignite.play()
	
	for n in range(numPoints):
		
		smokeRadii.append(rand_range(5, 10))
	
	pass

#func _draw() -> void:
#
#	if $Fire.polygon.empty():
#		return
#
#	var t = OS.get_system_time_msecs()
#
#	for n in range(1, numPoints):
#		draw_circle((float(n)/numPoints)*$Fire.polygon[1], ((sin(n-(t*0.02))+1)/2)*smokeRadii[n], Color(0.917647, 0.090196, 0.090196))
#		draw_circle((float(n)/numPoints)*$Fire.polygon[2], ((sin(n-(t*0.02))+1)/2)*smokeRadii[n], Color(0.917647, 0.090196, 0.090196))

func _on_Flamethrower_body_entered(body: Node) -> void:
	if body.has_method("ignite"):
		body.ignite()
		
var frames:int = 0

func _physics_process(delta: float) -> void:
	
	var leftBound:Vector2 = global_position+Vector2(distance, 0).rotated(global_rotation-deg2rad(spread/2))
	var rightBound:Vector2 = global_position+Vector2(distance, 0).rotated(global_rotation+deg2rad(spread/2))
	
	var rL = get_world_2d().direct_space_state.intersect_ray(global_position, global_position+Vector2(distance, 0).rotated(global_rotation-deg2rad(spread/2)), [], 0b10)
	var rR = get_world_2d().direct_space_state.intersect_ray(global_position, global_position+Vector2(distance, 0).rotated(global_rotation+deg2rad(spread/2)), [], 0b10)
	
	if rL:
		leftBound = rL.position
	if rR:
		rightBound = rR.position
	
	var leftSide:PoolVector2Array = []
	var rightSide:PoolVector2Array = []
	
	for n in range(1, numPoints):
		
		leftSide.append(to_local(global_position+((float(n)/numPoints)*(leftBound-global_position))))
		
	for n in range(1, numPoints):
		rightSide.append(to_local(global_position+((float(n)/numPoints)*(rightBound-global_position))))
	
	var points := PoolVector2Array([Vector2(0, 0), to_local(leftBound), to_local(rightBound)])
#	points.append_array(leftSide)
#	points.append_array(rightSide)
	$Fire.polygon = points
	
	update()
	
	#$Fire.polygon = PoolVector2Array([Vector2(0, 0), $Fire.to_local(leftBound), $Fire.to_local(rightBound)])
	


func _on_Firerate_timeout() -> void:
	return
	for n in range(5):
		var f = Flame.instance()
		get_parent().get_parent().add_child(f)
		f.global_position = global_position
		f.speed *= rand_range(1, 1.5)
		f.global_rotation = global_rotation+rand_range(-PI/8, PI/8)


func _on_Time_timeout() -> void:
	queue_free()
