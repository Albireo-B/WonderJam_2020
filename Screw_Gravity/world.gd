extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var letterScene = load("res://letter.tscn")
	var alpha = "a".to_ascii()
	for i in range(0,26):
		var letter = letterScene.instance()
		letter.speed = 2
		
		var newalpha = alpha
		newalpha[0] = alpha[0]+i
		var mesh = load("res://assets/alphabet/"+newalpha.get_string_from_ascii()+".obj")
		letter.get_node("MeshInstance").set_mesh(mesh)
		
		get_node("/root/world/plan").add_child(letter)
		

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
