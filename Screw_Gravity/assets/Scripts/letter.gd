extends KinematicBody


# Declare member variables here.
export var speed = 0.01
export var invisibility = false
export var box = Vector3(6,2.5,2)
export var difficulty = 0

onready var originpos = global_transform.origin
onready var randtarget = originpos
#letter MUST BE SET WHIT THE SETTER (using setter getter is better)
var letter;
#on each frame, on chance out of invdiff
var invdiff = 10000000000

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = randtarget - global_transform.origin
	if direction.length() < .1:
		var newpos = new_destination()
		randtarget = originpos + newpos
	else:
		move_and_slide(direction.normalized()*speed)
	
	if visible == true && invisibility && randi()%invdiff == 1:
		get_node("cloak").start()
		get_node("MeshInstance").get_node("cloak").visible = true
	
	
func new_destination():
	return Vector3((randf()*box.x-box.x/2.0),(randf()*box.y-box.y/2.0),(randf()*box.z-box.z/2.0))
	
func set_letter(letter_): 
	letter = letter_
	var mesh = load("res://Materials/alphabet/"+letter_+".obj")
	get_node("MeshInstance").set_mesh(mesh)
	
func get_letter(): 
	return letter
	
func get_difficulty():
	return difficulty
	
func set_difficulty(number):
	difficulty = number
	match number:
		0:
			speed = 0.1
			invisibility = false
		1:
			speed = 1
			invisibility = false
		2:
			speed = 1
			invisibility = true
			invdiff = 1000
		3:
			speed = 1
			invisibility = true
			invdiff = 500
		4:
			speed = 1.5
			invisibility = true
			invdiff = 500


func _on_cloak_timeout():
	get_node("MeshInstance").get_node("cloak").visible = false
