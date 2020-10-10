extends KinematicBody


# Declare member variables here.
export var speed = 1
onready var originpos = global_transform.origin
onready var randtarget = originpos
#letter MUST BE SET WHIT THE SETTER (using setter getter is better)
var letter;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = randtarget - global_transform.origin
	var box = Vector3(7,4,2)
	if direction.length() < 1:
		var newpos = Vector3((randf()*box.x-box.x/2),(randf()*box.y-box.y/2),(randf()*box.z-box.z/2))
		randtarget = originpos + newpos
	else:
		move_and_slide(direction.normalized()*speed)
	

func set_letter(letter_): 
	letter = letter_
	var mesh = load("res://assets/alphabet/"+letter_+".obj")
	get_node("MeshInstance").set_mesh(mesh)
	
func get_letter(): 
	return letter
