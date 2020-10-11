extends Label


# Declare member variables here.
export var time = 3.0
onready var rootNode = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rootNode.playtime:
		if time <= 0 :
			time = 0
			rootNode.playtime = false
			rootNode.changeSceneOrEndGame()
		else:
			time -= delta
	text = str(time)
