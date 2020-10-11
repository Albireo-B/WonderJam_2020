extends Label


# Declare member variables here.
export var time = 30.0
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
			rootNode.get_node("SaveSystem").highscore = rootNode.get_node("ui/score").score
			rootNode.get_node("SaveSystem").saveValue("scores", "score1")
			rootNode.changeSceneOrEndGame()
		else:
			time -= delta
	text = str(time)
