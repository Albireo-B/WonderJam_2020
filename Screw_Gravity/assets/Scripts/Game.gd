extends Spatial


onready var transitionScene = get_node("SceneTransitionRect")
onready var tween = get_node("Movement_Tween")
onready var cameraRaycast = get_node("Camera/RayCast")
onready var dialogBox = get_node("Dialog_Box")
onready var letterScene = preload("res://assets/Scenes/letter.tscn")
onready var islandIntermediate = preload("res://assets/Scenes/IslandIntermediate.tscn")
onready var islandComplete = preload("res://assets/Scenes/IslandComplete.tscn")
onready var placeholderplan = get_node("/root/RootNode/placeholder/Plan")


const CAM_POS = Vector3(0,4,4.45)
const CAM_ROT = Vector3(-10,0,0)

var wordList = [
	"it was" , "not meant" , "that we" , "should voyage" , "this far",
"ultimate horror" , "often paralyses" , "memory in" , "a merciful way",
"the world is" , "indeed comic" ,  "but the" , "joke is" , "on mankind",
"pleasure to me" , "is wonder",
"changeless thing" , "that lurks"  , "behind" , "the veil"  , "of reality",
"unless they happen" , "to be insane",
"and with" , "strange aeons" , "even death" , "may die",
"formless" , "infinite" , "unchanging" , "and unchangeable" , "void",
"where they" , "roll in" , "their horror" , "unheeded"
]

var zoomed = false
var level1DialogArrays = ["That is not [color=#4ab3ff]dead[/color] which can eternal lie",
"[color=#4ab3ff]A[/color] stranger [color=#4ab3ff]among[/color] those who are still [color=#4ab3ff]men[/color]"]
var level2DialogArrays = ["[color=#4ab3ff]The[/color] oldest and strongest emotion of mankind is [color=#4ab3ff]fear[/color]",
"I have seen the [color=#4ab3ff]Elders[/color] dancing"]
var level3DialogArrays = ["[b]Don't ever stop ![/b]"]

var levelsAnswer = ["a dead among men","fear the elders"]

var allDialogueRead = false
var selectedLetter = null
var selectedbody = null
var inLetterGame = false
var currentIslandSceneIndex = 1
var currentIslandNode
var sentence = ""
var currentNode
var spacing = 0.25


func selectAlpha(obj, selected):
	obj.get_node("MeshInstance").get_node("outline").visible = selected

# Called when the node enters the scene tree for the first time.
func _ready():
	currentIslandNode = get_node("Environment")
	var alpha = "a".to_ascii()
	for i in range(0,26):
		var letter = letterScene.instance()
		letter.set_difficulty(4)
		var newalpha = alpha
		newalpha[0] = alpha[0]+i
		letter.set_letter(newalpha.get_string_from_ascii())
		letter.translate(letter.new_destination())
		get_node("/root/RootNode/Zone_Lettres/Plan").add_child(letter) 
	switchMode()

func start(sentence_):
	print(sentence)
	for child in placeholderplan.get_children():
		child.queue_free()
	for child in get_node("/root/RootNode/answer").get_children():
		child.queue_free()
	
	sentence = sentence_
	var iterator = 0
	for letter in sentence:
		if letter != " ":
			var letterNode = letterScene.instance()
			letterNode.speed = 0
			letterNode.set_letter(letter)
			placeholderplan.add_child(letterNode)
			letterNode.translate(Vector3((-sentence.length()*spacing)/2+iterator * spacing,0,0))
			letterNode.visible = false
			letterNode.get_node("CollisionShape").queue_free()
		iterator+=1
	nextCar()

func nextCar():
	placeholderplan.get_child(0).queue_free()		
	var letterNode = placeholderplan.get_child(1)
	selectAlpha(letterNode,true)
	letterNode.visible = true
	currentNode = letterNode	
	
func _process(delta):
	if inLetterGame:
		if cameraRaycast.is_colliding():
			selectedLetter = cameraRaycast.get_collider()
			if  inplan(selectedLetter):
					selectAlpha(selectedLetter,true)
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(selectedLetter)
		else :
			clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	else:
		if cameraRaycast.is_colliding() and !dialogBox.visible:
			selectedbody = cameraRaycast.get_collider()
			selectedbody.get_child(0).get_node("Outline").visible = true
		else :
			clearBodiesOutline()

						
func zoomInAndDialog(targetObject):
	get_node("Camera").set_enabled(false)
	get_node("Camera/Sprite3D").visible = false
	get_node("Camera/RayCast").enabled = false
	if targetObject.get_name() == "Human_one":
		moveObject(get_node("Camera"),Vector3(-3.35,3,-1),Vector3(0,0,0))
	else:
		moveObject(get_node("Camera"),Vector3(2.128,3.105,-1.937),Vector3(10,-90,0))

func zoomOutAndDialog():
	dialogBox.visible = false
	moveObject(get_node("Camera"),CAM_POS,CAM_ROT)
	
func displayAccordingMessage():
	match currentIslandSceneIndex:
		1:
			var index = randi()%level1DialogArrays.size()
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").bbcode_text = "[center]"+level1DialogArrays[index]+"[/center]"
			level1DialogArrays.remove(index)
			if level1DialogArrays.size() == 0:
				allDialogueRead = true
		2:
			var index = randi()%level2DialogArrays.size()
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").bbcode_text = "[center]"+level2DialogArrays[randi()%level1DialogArrays.size()]+"[/center]"
			level2DialogArrays.remove(index)
			if level2DialogArrays.size() == 0:
				allDialogueRead = true
		3:
			var index = randi()%level3DialogArrays.size()
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label").bbcode_text = "[center]"+level3DialogArrays[randi()%level1DialogArrays.size()]+"[/center]"
			level3DialogArrays.remove(index)
			if level3DialogArrays.size() == 0:
				allDialogueRead = true

func clearBodiesOutline():
	if selectedbody:
		selectedbody.get_child(0).get_node("Outline").visible = false
		
#deactivate collision mesh to allow the raycast to find the letter and inversely
func switchMode(sentence=null):
	clearBodiesOutline()
	clearAllLettersExceptSelectedOneOhGodWhatHaveIDone(null)
	if inLetterGame:
		switchCollisions("Bodies",false)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = true
		if sentence:
			start(sentence)
		switchCollisions("Letters",true)
	else:
		switchCollisions("Bodies",true)
		for L in get_node("Zone_Lettres/Plan").get_children():
			L.visible = false
		for L in get_node("placeholder/Plan").get_children():
			L.visible = false
		for L in get_node("answer").get_children():
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
		if L != letter:
			selectAlpha(L,false)

func inplan(obj):
	return obj.get_parent() == get_node("/root/RootNode/Zone_Lettres/Plan")
	
func moveObject(object,targetLocation,rotationNeeded):
	if object is KinematicBody:
		var letter = object
		var newletter = letter.duplicate()
		var oldpos = letter.global_transform.origin
		get_node("/root/RootNode/answer").add_child(newletter)
		newletter.translation = oldpos
		newletter.speed = 0
		newletter.get_node("CollisionShape").queue_free()
		selectAlpha(newletter, false)
		tween.interpolate_property(newletter,"translation",newletter.translation,
		targetLocation,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.interpolate_property(newletter,"rotation_degrees",newletter.rotation_degrees,
		rotationNeeded,2.0,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
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
	allDialogueRead = false
	
func endGame():
	get_tree().quit()
	
func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("ui_cancel"):
			changeSceneOrEndGame()
	if event is InputEventMouseButton:
		if event.pressed:
			if inLetterGame:
				var obj = cameraRaycast.get_collider()
				if cameraRaycast.is_colliding() && inplan(obj) && istheletter(obj) :
					moveObject(obj,currentNode.global_transform.origin,Vector3(-30,0,0))
					if placeholderplan.get_child(1):
						nextCar()
					else:
						switchMode()
						changeSceneOrEndGame()
			else :
				if !dialogBox.visible:
					if cameraRaycast.is_colliding():
						zoomInAndDialog(cameraRaycast.get_collider())
						zoomed = true
				else:
					zoomOutAndDialog()
					zoomed = false

func istheletter(obj):
	return obj.get_letter() == currentNode.get_letter()
	
func _on_Movement_Tween_tween_all_completed():
	if !inLetterGame:
		if zoomed:
			displayAccordingMessage()	
			dialogBox.get_node("Body_NinePatchRect/Body_MarginContainer/Body_Label/Body_AnimationPlayer").play("TextDisplay")
			dialogBox.visible = true
		elif allDialogueRead:
			inLetterGame = !inLetterGame
			get_node("Camera/Sprite3D").visible = true
			get_node("Camera").set_enabled(true)
			get_node("Camera/RayCast").enabled = true
			switchMode(levelsAnswer[currentIslandSceneIndex-1])
		else :
			get_node("Camera/Sprite3D").visible = true
			get_node("Camera").set_enabled(true)
			get_node("Camera/RayCast").enabled = true
	else:
		pass

