extends Spatial


onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
var coloredMaterial = SpatialMaterial.new()
var xSpaceLetters = -3
var activatedLetterList = Array()
var selectedLetter = null

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
		get_node("/root/RootNode/Zone_Lettres/Plan").add_child(letter) 


func _process(delta):
	if cameraRaycast.is_colliding():
		selectedLetter = cameraRaycast.get_collider()
		coloredMaterial.albedo_color = Color.red
		selectedLetter.get_node("MeshInstance").set_material_override(coloredMaterial)
		clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)

func clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(letter):
	for L in get_node("Zone_Lettres/Plan").get_children():
		coloredMaterial = SpatialMaterial.new()
		coloredMaterial.albedo_color = Color.white
		if L != letter and !L in activatedLetterList:
			L.get_node("MeshInstance").set_material_override(coloredMaterial)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if cameraRaycast.is_colliding() && !cameraRaycast.get_collider() in activatedLetterList :
				activatedLetterList.append(cameraRaycast.get_collider())
				moveLetter(cameraRaycast.get_collider())
				
				
func moveLetter(letter):
		letter.speed = 0
		var targetLocation = Vector3(xSpaceLetters,0,0)
		var rotationNeeded = Vector3(-30,0,0)
		tween.interpolate_property(letter,"translation",letter.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(letter,"rotation_degrees",letter.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		xSpaceLetters+=0.7
