extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var rootNode = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	rootNode.get_node("SaveSystem").loadValue("scores", "score1")
	text = str(rootNode.get_node("SaveSystem").highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(rootNode.get_node("SaveSystem").highscore)

