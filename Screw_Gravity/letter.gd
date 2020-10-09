extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var osrange = 20.0
export var osspeed = 1.0
var ascend = 1
var pos = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pos < 0:
		ascend = 1
	elif pos > osrange:
		ascend = -1
	pos = pos + ascend*osspeed
	move_and_slide(Vector3(0,osspeed*ascend,0))
