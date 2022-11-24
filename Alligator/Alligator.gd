extends KinematicBody2D

class_name Alligator

export var health:int = 1
export var moveSpeed:float = 300
export var acceleration:float = 0.5

export var invincible:bool = false

var velocity:Vector2

onready var legs = $Graphics/Legs
onready var weaponPivot = $Weapon/Pivot
onready var weapon = $Weapon/Pivot.get_child(0)
onready var camera = $Camera
onready var lives: MarginContainer = $UI/Lives
onready var heartContainer: HBoxContainer = $UI/Lives/PanelContainer/HBoxContainer
var LifeScene = preload("res://Alligator/Life.tscn")

var Spit = preload("res://Alligator/SpitParticles.tscn")

var swallowedObjects = []
var swallowAreaBodies = []
var swallowing:bool = false
	
var dead:bool = false

signal restart()

export var hasGun:bool = true setget setHasGun
export var canMove:bool = true
export var canAct:bool = true

func setHasGun(val):
	hasGun = val
	$Weapon.visible = hasGun
	if hasGun:
		$Weapon/Pivot/Revolver.show()
	else:
		$Weapon/Pivot/Revolver.hide()

func _ready() -> void:
	weapon.alligator = self
	get_tree().set_group("Enemy", "alligator", self)
	
	if health <= 1:
		lives.hide()
	else:
		for _l in range(health-1):
			var heart = LifeScene.instance()
			heartContainer.add_child(heart)

func getMoveDir() -> Vector2:
	
	var dir:Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	
	return dir.normalized()
	
func movement(delta:float):
	
	velocity = move_and_slide(velocity.linear_interpolate(getMoveDir()*moveSpeed, acceleration*delta*60))
	
	global_rotation = lerp_angle(global_rotation, (get_global_mouse_position()-global_position).angle(), 0.5*delta*60)
	
	if velocity.length() > 0 and not legs.playing:
		legs.play("walk")
	elif velocity.length() <= 3:
		legs.stop()
		
	legs.global_rotation = velocity.angle()+(PI/2)
	
export var lookDistance:float = 220
export var lookSpeed:float = 0.5
	
func actions(delta:float):
	
	if Input.is_action_pressed("look"):
		camera.position = camera.position.linear_interpolate(Vector2(lookDistance, 0), lookSpeed*delta*60)
	else:
		camera.position = camera.position.linear_interpolate(Vector2(0, 0), lookSpeed*delta*60)
	
	weaponPivot.global_rotation = lerp_angle(weaponPivot.global_rotation, (get_global_mouse_position()-weaponPivot.global_position).angle(), 0.5*delta*60)
	$Lighter/AnimatedSprite.global_rotation = 0
	
	if hasGun:
	
		if Input.is_action_just_pressed("reload"):
			weapon.reload()
			
		if Input.is_action_just_pressed("attack"):
			weapon.attack(get_global_mouse_position())
	
	if Input.is_action_just_pressed("bite"):
		if swallowedObjects.empty() and not $Graphics/Torso/Head/Animation.is_playing():
			bite()
		elif not swallowedObjects.empty():
			spit()
		
export var spitSpreadDegrees:float = 20
onready var spitSpread = deg2rad(spitSpreadDegrees)
		
func spit():
	
	$Lighter/Lighter.stop()
	
	var meat:bool = false
	var bullets:int = 0
	var objectTypes:Dictionary = {}
	for body in swallowedObjects:
		if not objectTypes.has(body.filename):
			objectTypes[body.filename] = [body]
		else:
			objectTypes[body.filename].append(body)
			
	for objectType in objectTypes.keys():
		for index in objectTypes[objectType].size():
			var obj = objectTypes[objectType][index]
			if objectTypes[objectType].size() > 1:
				var n = float(index)/(objectTypes[objectType].size()-1)
				var angle = global_rotation-(spitSpread/2)+((spitSpread/2)*n)
				obj.spit(self, angle)
			else:
				obj.spit(self, global_rotation)
			if obj.is_in_group("Meat"):
				meat = true
			if obj.is_in_group("Bullet"):
				bullets += 1
			yield(get_tree().create_timer(0.01), "timeout")
			
	swallowedObjects.clear()
	$Graphics/Torso/Head/Normal.play("spit")
	$Spit.pitch_scale = 1+rand_range(0, 0.3)
	$Spit.play()
	
	if bullets > 0:
		$SpitBullets.volume_db = 0+((bullets-1)*1.2)
		$SpitBullets.play()
	
	if meat:
		var s = Spit.instance()
		get_parent().add_child(s)
		s.global_position = global_position
		s.global_rotation = global_rotation
		s.color = Color(1, 0.219608, 0.219608) if meat else Color(0.284991, 0.612786, 0.828125, 0.388235)
			
func bite():
	$Bite.pitch_scale = 0.8+rand_range(-0.2, 0)
	$Bite.play()
	$Graphics/Torso/Head/Animation.play("Bite")
	
			
func biteDamage():
	for body in $BiteArea.get_overlapping_bodies():
		if body.is_in_group("Eatable"):
			body.bite(self)

func _physics_process(delta: float) -> void:
	if not dead:
		if canMove:
			movement(delta)
		else:
			$Graphics/Legs.play("default")
		if canAct:
			actions(delta)
	else:
		if Input.is_action_just_pressed("restart"):
			restart()
			
func restart():
	emit_signal("restart")

func startSwallow():
	swallowing = true
	for object in swallowAreaBodies:
		swallow(object)
		
func stopSwallow():
	swallowing = false
	
func swallow(object):
	if swallowedObjects.empty():
		$Graphics/Torso/Head/Normal.play("full")
		$Swallow.pitch_scale = 1+rand_range(-0.2, 0)
		$Swallow.play()
	if object.has_method("swallow"):
		object.swallow()
	if object.is_in_group("Ethanol") and not $Lighter.visible:
		$Lighter.show()
		$Lighter/Lighter.play()
	swallowedObjects.append(object)
	if object in swallowAreaBodies:
		swallowAreaBodies.erase(object)

func _on_SwallowArea_body_entered(body: Node) -> void:
	if body.is_in_group("Swallowable") and not body in swallowAreaBodies:
		if swallowing:
			swallow(body)
		else:
			swallowAreaBodies.append(body)


func _on_SwallowArea_body_exited(body: Node) -> void:
	if body in swallowAreaBodies:
		swallowAreaBodies.erase(body)


func _on_SwallowArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("Swallowable") and not area in swallowAreaBodies:
		if swallowing:
			swallow(area)
		else:
			swallowAreaBodies.append(area)


func _on_SwallowArea_area_exited(area: Area2D) -> void:
	if area in swallowAreaBodies:
		swallowAreaBodies.erase(area)

func hit(damage:int, dir:float=0):
	
	if invincible:
		return
	
	if dead:
		return
		
	elif health > 1:
		
		heartContainer.get_child(health-1).get_node("Animation").play("Break")
		health = int(max(0, health-damage))
		
	else:
		
		dead = true
		heartContainer.get_child(0).get_node("Animation").play("Break")
		$Graphics/Torso/Head/Animation.stop(true)
		stopSwallow()
		#$CollisionShape2D.set_deferred("disabled", true)
		$Graphics.hide()
		$Body.show()
		$Body.global_rotation = dir
		$Weapon.hide()
		$Lighter.hide()
		spawnBlood()
		$UI/Restart.show()
		$Grey/Animation.play("FadeIn")
		
	camera.shake(20, 0.2, 20)
	
		
var Blood = preload("res://Blood/Blood.tscn")
		
func spawnBlood():
	
	for n in range(5):
		var b = Blood.instance()
		get_parent().add_child(b)
		b.global_position = global_position+(Vector2(10, 0).rotated(2*PI*(float(n)/5)))
	var t = Blood.instance()
	get_parent().add_child(t)
	t.global_position = global_position
	t.z_index = 10
	t.scale = Vector2(0.5, 0.5)
	
func flamesFinished():
	if $Flames.get_child_count() <= 1:
		$Lighter.hide()
