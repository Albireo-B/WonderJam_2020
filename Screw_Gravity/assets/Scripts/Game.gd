extends Spatial


onready var transitionScene = get_node("SceneTransitionRect")
onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
onready var dialogBox = get_node("Dialog_Box")
onready var letterScene = preload("res://assets/Scenes/letter.tscn")
onready var islandIntermediate = preload("res://assets/Scenes/IslandIntermediate.tscn")
onready var islandComplete = preload("res://assets/Scenes/IslandComplete.tscn")

const CAM_POS = Vector3(0,4,4.45)
const CAM_ROT = Vector3(-10,0,0)

var coloredMaterial = SpatialMaterial.new()
var xSpaceLetters = -3
var activatedLetterList = Array()
var selectedLetter = null
var selectedbody = null
var inLetterGame = false
var currentIslandSceneIndex = 1
var currentIslandNode
var level1DialogArrays = ["What happened here?","I can't remember anything","Poor guys"]
var level2DialogArrays = ["Hi there","General kenobi","Bip","Boup","tryndamere est passé par la"]
var level3DialogArrays = ["Hi there","General kenobi","Bip","Boup","tryndamere est passé par la"]

# Called when the node enters the scene tree for the first time.
func _ready():
	currentIslandNode = get_node("Environment")
	var alpha = "a".to_ascii()
	for i in range(0,26):
		var letter = letterScene.instance()
		letter.speed = 1
		var newalpha = alpha
		newalpha[0] = alpha[0]+i
		var mesh = load("res://Materials/alphabet/"+newalpha.get_string_from_ascii()+".obj")
		letter.get_node("MeshInstance").set_mesh(mesh)
		get_node("/root/RootNode/Zone_Lettres/Plan").add_child(letter) 
	switchMode()


func _process(delta):
	if inLetterGame:
		if cameraRaycast.is_colliding():
			selectedLetter = cameraRaycast.get_collider()
			coloredMaterial.albedo_color = Color.red
			if selectedLetter is KinematicBody:
				selectedLetter.get_node("MeshInstance").set_material_override(coloredMaterial)
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)
		else :
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	else:
		if cameraRaycast.is_colliding() and !dialogBox.visible:
			selectedbody = cameraRaycast.get_collider()
			selectedbody.get_child(0).get_node("Outline").visible = true
		else :
			clearBodiesOutline()


func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_cancel"):
			changeSceneOrEndGame()
	if event is InputEventMouseButton:
		if event.pressed:
			if inLetterGame:
				if cameraRaycast.is_colliding() && !cameraRaycast.get_collider() in activatedLetterList :
					activatedLetterList.append(cameraRaycast.get_collider())
					moveObject(cameraRaycast.get_collider(),Vector3(xSpaceLetters,0,0),Vector3(-30,0,0))
			else :
				if !dialogBox.visible:
					if cameraRaycast.is_colliding():
						zoomInAndDialog(cameraRaycast.get_collider())
				else:
					zoomOutAndDialog()
						
func zoomInAndDialog(targetObject):
	get_node("Camera").set_enabled(false)
	get_node("Camera/Sprite3D").visible = false
	get_node("Camera/RayCast").enabled = false
	if targetObject.get_name() == "Human_one":
		moveObject(get_node("Camera"),Vector3(-3.35,3,-1),Vector3(0,0,0))
	else:
		moveObject(get_node("Camera"),Vector3(2.128,3.105,-1.937),Vector3(10,-90,0))

func zoomOutAndDialog():
	moveObject(get_node("Camera"),CAM_POS,CAM_ROT)
	get_node("Camera/Sprite3D").visible = true
	get_node("Camera").set_enabled(true)
	get_node("Camera/RayCast").enabled = true
	
func displayAccordingMessage():
	match currentIslandSceneIndex:
		1:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level1DialogArrays[randi()%level1DialogArrays.size()]
		2:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level2DialogArrays[randi()%level2DialogArrays.size()]
		3:
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").text = level2DialogArrays[randi()%level2DialogArrays.size()]
			
func clearBodiesOutline():
	if selectedbody:
		selectedbody.get_child(0).get_node("Outline").visible = false
		
#deactivate collision mesh to allow the raycast to find the letter and inversely
func switchMode():
	clearBodiesOutline()
	clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	if inLetterGame:
		switchCollisions("Bodies",false)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = true
		switchCollisions("Letters",true)
	else:
		switchCollisions("Bodies",true)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = false
		switchCollisions("Letters",false)

func switchCollisions(objectsType,enabled):
	if objectsType == "Bodies":
		for N in currentIslandNode.get_node("Dead_Bodies").get_children():
			for i in range (1,N.get_children().size()-1):
				N.get_child(i).disabled = !enabled
	else :
		for N in get_node("Zone_Lettres/Plan").get_children():
			N.get_node("CollisionShape").disabled = !enabled
			


func clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(letter):
	for L in get_node("Zone_Lettres/Plan").get_children():
		coloredMaterial = SpatialMaterial.new()
		coloredMaterial.albedo_color = Color.white
		if L != letter and !L in activatedLetterList:
			L.get_node("MeshInstance").set_material_override(coloredMaterial)
	
func moveObject(object,targetLocation,rotationNeeded):
	if object is KinematicBody:
		object.speed = 0
		tween.interpolate_property(object,"translation",object.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(object,"rotation_degrees",object.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		xSpaceLetters+=0.7
	elif object is Camera:
		tween.interpolate_property(object,"translation",object.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(object,"rotation_degrees",object.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		
		
func changeSceneOrEndGame():
		match currentIslandSceneIndex:
			1:
				fadeIn_IncrScene_ChangeEnv(islandIntermediate)
			2:
				fadeIn_IncrScene_ChangeEnv(islandComplete)
			3:
				endGame()

func fadeIn_IncrScene_ChangeEnv(newEnv):
	transitionScene.get_node("AnimationPlayer").play("Fade_in")
	yield(transitionScene.get_node("AnimationPlayer"), "animation_finished")
	currentIslandNode.queue_free()
	var newInstance = newEnv.instance()
	currentIslandNode = newInstance
	get_tree().get_root().get_node("RootNode").add_child(newInstance)
	transitionScene.get_node("AnimationPlayer").play("Fade_out")
	currentIslandSceneIndex+=1
	
func endGame():
	get_tree().quit()

func _on_Movement_Tween_tween_all_completed():
	if !inLetterGame:
		if !dialogBox.visible:
			displayAccordingMessage()	
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label/Body_AnimationPlayer").play("TextDisplay")
			dialogBox.visible = true
		else:
			dialogBox.visible = false
			inLetterGame = !inLetterGame
			switchMode()
