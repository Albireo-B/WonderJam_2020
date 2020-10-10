extends Spatial


onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
onready var dialogBox = get_node("Dialog_Box")
onready var letterScene = preload("res://letter.tscn")


var coloredMaterial = SpatialMaterial.new()
var xSpaceLetters = -3
var activatedLetterList = Array()
var selectedLetter = null
var selectedbody = null
var inLetterGame = true

# Called when the node enters the scene tree for the first time.
func _ready():
	switchMode()
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
	if inLetterGame:
		if cameraRaycast.is_colliding():
			selectedLetter = cameraRaycast.get_collider()
			coloredMaterial.albedo_color = Color.red
			selectedLetter.get_node("MeshInstance").set_material_override(coloredMaterial)
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)
		else :
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	else:
		if cameraRaycast.is_colliding():
			selectedbody = cameraRaycast.get_collider()
			selectedbody.get_node("Dead_body_one/Outline").visible = true
		else :
			clearBodiesOutline()

func clearBodiesOutline():
	if selectedbody:
		selectedbody.get_node("Dead_body_one/Outline").visible = false
	
#deactivate collision mesh to allow the raycast to find the letter and inversely
func switchMode():
	clearBodiesOutline()
	clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	if inLetterGame:
		switchCollisions("Bodies",false)
		switchCollisions("Letters",true)
	else:
		switchCollisions("Bodies",true)
		switchCollisions("Letters",false)	

func switchCollisions(objectsType,enabled):
	if objectsType == "Bodies":
		for N in get_node("Environment/Dead_Bodies").get_children():
			for i in range (1,N.get_children().size()-1):
				N.get_child(i).disabled = !enabled
				print("Collision disabled for "+N.get_name())
	else :
		for N in get_node("Zone_Lettres/Plan").get_children():
			N.get_node("CollisionShape").disabled = !enabled


func clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(letter):
	for L in get_node("Zone_Lettres/Plan").get_children():
		coloredMaterial = SpatialMaterial.new()
		coloredMaterial.albedo_color = Color.white
		if L != letter and !L in activatedLetterList:
			L.get_node("MeshInstance").set_material_override(coloredMaterial)
	
func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_accept"):
			inLetterGame = !inLetterGame
			switchMode()
	if event is InputEventMouseButton:
		if event.pressed:
			if inLetterGame:
				if cameraRaycast.is_colliding() && !cameraRaycast.get_collider() in activatedLetterList :
					activatedLetterList.append(cameraRaycast.get_collider())
					moveLetter(cameraRaycast.get_collider())
			else :
				if cameraRaycast.is_colliding():
					dialogBox.visible = !dialogBox.visible
				
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
