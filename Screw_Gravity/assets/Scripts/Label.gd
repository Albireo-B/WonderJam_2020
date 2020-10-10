extends Label


# Declare member variables here.
export var time = 30.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var worldNode = get_node("/root/world")
	if worldNode.playtime:
		if time <= 0 :
			time = 0
			worldNode.playtime = false
		else:
			time -= delta
	text = str(time)
