extends Label


# Declare member variables here. Examples:
export var score = 0
onready var rootNode = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if rootNode.playtime:
		score += 1
		if score > rootNode.get_node("SaveSystem").highscore:
			rootNode.get_node("SaveSystem").highscore = rootNode.get_node("ui/score").score
			rootNode.get_node("SaveSystem").saveValue("scores", "score1")
	text = str(score)
