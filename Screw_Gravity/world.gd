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
		letter.set_letter(newalpha.get_string_from_ascii())
		
		get_node("/root/world/plan").add_child(letter)
		
	newletter()
	

func newletter():
	var letterScene = load("res://letter.tscn")
	var alpha = "a".to_ascii()
	alpha[0] += randi()%26+1
	
	var letter = letterScene.instance()
	letter.speed = 0
	letter.set_letter(alpha.get_string_from_ascii())
	
	get_node("/root/world/placeholder").add_child(letter)

	var coloredMaterial = SpatialMaterial.new()
	coloredMaterial.albedo_color = Color.red

	letter.get_node("MeshInstance").set_material_override(coloredMaterial)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
